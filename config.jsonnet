local BUILD = importstr 'BUILD';

local docker = (
  local projects = [
    'chorebot',
    'jenkins',
    'vault',
  ];
  {
    projects: projects,
    login():: (
      'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
    ),
    compose(cmd):: (
      'docker-compose -f docker/docker-compose.yml %s' % cmd
    ),
    images: {
      [project]: 'arecker/%s:latest' % project
      for project in projects
    },
    asComposeFile():: (
      {
        version: '3',
        services: {
          [project]: {
            image: 'arecker/%s:latest' % project,
            build: { context: project },
          }
          for project in projects
        },
      }
    ),
  }
);

local travis = {
  asTravisFile():: {
    language: 'bash',
    arch: ['arm64'],
    services: ['docker'],
    branches: { only: ['master'] },
    notifications: { email: false },
    jobs: {
      include: [
        {
          stage: 'docker',
          script: [
            docker.login(),
            docker.compose('build --parallel'),
            docker.compose('push'),
          ],
        },
      ],
    },
  },
};

local kubernetes = {
  ingress(rules, metadata={}):: (
    local ingressRule(serviceName, servicePort) = (
      {
        host: serviceName + '.local',
        http: {
          paths: [
            {
              backend: {
                serviceName: serviceName,
                servicePort: servicePort,
              },
            },
          ],
        },
      }
    );
    {
      apiVersion: 'networking.k8s.io/v1beta1',
      kind: 'Ingress',
      spec: {
        rules: [
          ingressRule(
            serviceName=rule.serviceName,
            servicePort=rule.servicePort
          )
          for rule in rules
        ],
      },
    } + { metadata: metadata }
  ),
  container(
    name,
    image,
    env={},
    volumes={},
    roVolumes={},
    pullPolicy='Always',
    securityContext={},
    ports=[],
  ):: (
    {
      name: name,
      image: image,
      imagePullPolicy: pullPolicy,
      ports: ports,
      securityContext: securityContext,
      env: [
        {
          name: k,
          value: env[k],
        }
        for k in std.objectFields(env)
      ],
      volumeMounts: [
        {
          name: k,
          mountPath: volumes[k],
        }
        for k in std.objectFields(volumes)
      ] + [
        {
          name: k,
          mountPath: roVolumes[k],
          readOnly: true,
        }
        for k in std.objectFields(roVolumes)
      ],
    }
  ),
  addSecretboiInit(role='', once=false, paths={}, podTemplate={}):: (
    local addSecretMount(container) = (
      local mount = { name: 'secrets', mountPath: '/secrets', readOnly: true };
      container {
        volumeMounts: container.volumeMounts + [mount],
      }
    );

    local secretNames = std.objectFields(paths);

    local container = self.container(
      name='secretboi',
      image='arecker/secretboi:latest',
      volumes={ secrets: '/secrets' },
      env={
        VAULT_ADDR: 'http://vault.local',
        VAULT_ROLE: role,
        ONLY_RUN_ONCE: '%s' % once,
      } + {
        ['SECRET_%s' % k]: paths[k]
        for k in secretNames
      }
    );

    podTemplate {
      volumes: podTemplate.volumes + [{ name: 'secrets', emptyDir: {} }],
      containers: std.map(addSecretMount, podTemplate.containers) + [container],
    }
  ),
  podTemplate(containers=[], volumes=[], secrets={}, metadata={}):: (
    local data = {
      metadata: metadata,
      restartPolicy: 'OnFailure',
      volumes: volumes,
      containers: containers,
    };

    local podSecrets = {
      paths: {},
      once: false,
      role: '',
    } + secrets;

    if std.length(std.objectFields(podSecrets.paths)) == 0 then
      data
    else
      self.addSecretboiInit(
        podTemplate=data,
        role=podSecrets.role,
        once=podSecrets.once,
        paths=podSecrets.paths
      )
  ),
  deployment(info, podTemplate, metadata={}):: (
    {
      apiVersion: 'apps/v1beta1',
      kind: 'Deployment',
      metadata: metadata,
      template: podTemplate,
    } + info
  ),
  cron(schedule='', podTemplate={}, metadata={}):: (
    std.prune({
      apiVersion: 'batch/v1beta1',
      kind: 'CronJob',
      metadata: metadata,
      spec: {
        schedule: schedule,
        jobTemplate: { spec: { template: { spec: podTemplate } } },
      },
    })
  ),
};

local farm = {
  metadata: {
    name: 'farm',
    labels: {
      build: BUILD,
    },
  },
  asKubeConfig():: (
    local chorebotMetadata = self.metadata { name: 'chorebot' };

    local chorebotContainer = kubernetes.container(
      name=chorebotMetadata.name,
      image=docker.images.chorebot,
      pullPolicy='Always'
    );

    local chorebotPodTemplate = kubernetes.podTemplate(
      containers=[chorebotContainer],
      secrets={
        role: 'chorebot',
        once: true,
        paths: {
          WEBHOOK: '/slack/reckerfamily/webhook',
        },
      }
    );

    [
      kubernetes.ingress([
        { serviceName: 'hub', servicePort: 80 },
        { serviceName: 'jenkins', servicePort: 8080 },
        { serviceName: 'vault', servicePort: 8200 },
      ], metadata=self.metadata),

      kubernetes.cron(
        schedule='0 10 * * *',
        podTemplate=chorebotPodTemplate,
        metadata=chorebotMetadata
      ),
    ]
  ),
};

local vault = {
  metadata: {

  },
  asKubeConfig():: [

  ],
};

local nfs = {
  host: 'archive.local',
  asFarmMount(name):: (
    {
      name: name,
      nfs: {
        host: nfs.host,
        path: '/mnt/scratch/farm/' + name,
      },
    }
  ),
};

local jenkins = {
  metadata: {
    name: 'jenkins',
    labels: {
      build: BUILD,
    },
  },

  asKubeConfig():: (
    local metadata = self.metadata;

    local masterContainer = kubernetes.container(
      name='master',
      image=docker.images.jenkins,
      securityContext={ runAsUser: 1001 },
      ports=[{ containerPort: 8200 }],
      volumes={ 'jenkins-data': '/var/jenkins_home' },
    );

    local podTemplate = kubernetes.podTemplate(
      volumes=[nfs.asFarmMount('jenkins-data')],
      containers=[masterContainer],
      metadata=metadata
    );

    local deployment = kubernetes.deployment(info={
      version: 'apps/v1beta1',
      kind: 'Deployment',
      replicas: 1,
    }, podTemplate=podTemplate, metadata=metadata);

    [deployment]
  ),
};

{
  'docker/docker-compose.yml': std.manifestYamlDoc(docker.asComposeFile()),
  'kubernetes/farm.yml': std.manifestYamlStream(farm.asKubeConfig()),
  'kubernetes/jenkins.yml': std.manifestYamlStream(jenkins.asKubeConfig()),
}
