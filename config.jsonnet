local BUILD = importstr 'BUILD';

local docker = (
  local projects = [
    'chorebot',
    'hub-proxy',
    'hub-web',
    'jenkins',
    'jnlp',
    'vault',
  ];

  local projectConfigs = {
    [project]: {
      image: 'arecker/%s:latest' % project,
      build: {
        context: project,
        dockerfile: 'Dockerfile',
      },
    }
    for project in projects
  } + {
    'hub-proxy'+: {
      build+: {
        dockerfile: 'dockerfiles/Dockerfile.proxy',
        context: 'hub',
      },
    },
    'hub-web'+: {
      build+: {
        dockerfile: 'dockerfiles/Dockerfile.web',
        context: 'hub',
      },
    },
    jenkins+: {
      build+: {
        dockerfile: 'Dockerfile-alpine',
      },
    },
  };

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
          [project]: projectConfigs[project]
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
  service(name='', port='', metadata={}):: (
    {
      apiVersion: 'v1',
      kind: 'Service',
      metadata: metadata,
      spec: {
        ports: [{ port: port, protocol: 'TCP' }],
        selector: {
          service: name,
        },
      },
    }
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
      spec+: {
        volumes: podTemplate.spec.volumes + [{ name: 'secrets', emptyDir: {} }],
        containers: std.map(addSecretMount, podTemplate.spec.containers) + [container],
      },
    }
  ),
  podTemplate(containers=[], volumes=[], secrets={}, metadata={}, restartPolicy='Always'):: (
    local data = {
      metadata: metadata,
      spec: {
        restartPolicy: restartPolicy,
        volumes: volumes,
        containers: containers,
      },
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
  deployment(replicas, podTemplate, metadata={}):: (
    {
      apiVersion: 'apps/v1beta1',
      kind: 'Deployment',
      metadata: metadata,
      spec: {
        replicas: replicas,
        template: podTemplate,
      },
    }
  ),
  cron(schedule='', podTemplate={}, metadata={}):: (
    std.prune({
      apiVersion: 'batch/v1beta1',
      kind: 'CronJob',
      metadata: metadata,
      spec: {
        schedule: schedule,
        jobTemplate: { spec: { template: podTemplate } },
      },
    })
  ),
};

local chorebot = {
  metadata: {
    name: 'chorebot',
    labels: {
      build: BUILD,
    },
  },
  asKubeConfig():: (
    local metadata = self.metadata;

    local container = kubernetes.container(
      name=metadata.name,
      image=docker.images.chorebot,
      pullPolicy='Always'
    );

    local podTemplate = kubernetes.podTemplate(
      restartPolicy='OnFailure',
      containers=[container],
      secrets={
        role: 'chorebot',
        once: true,
        paths: {
          WEBHOOK: '/slack/reckerfamily/webhook',
        },
      }
    );

    local cron = kubernetes.cron(
      schedule='0 10 * * *',
      podTemplate=podTemplate,
      metadata=metadata
    );

    [cron]
  ),
};

local ingress = {
  metadata: {
    name: 'ingress',
    labels: {
      build: BUILD,
    },
  },
  asKubeConfig():: (
    [
      kubernetes.ingress([
        { serviceName: 'hub', servicePort: 80 },
        { serviceName: 'jenkins', servicePort: 8080 },
        { serviceName: 'vault', servicePort: 8200 },
      ], metadata=self.metadata),
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
        server: nfs.host,
        path: '/mnt/scratch/farm/' + name,
      },
    }
  ),
};

local jenkins = {
  metadata: {
    name: 'jenkins',
    labels: {
      service: 'jenkins',
      build: 'static',  // it's probably not a good idea to continuously deploy jenkins, right?
    },
  },

  asKubeConfig():: (
    local metadata = self.metadata;

    local masterContainer = kubernetes.container(
      name='master',
      image=docker.images.jenkins,
      securityContext={ runAsUser: 1001 },
      ports=[{ containerPort: 8080 }],
      volumes={ 'jenkins-data': '/var/jenkins_home' },
    );

    local podTemplate = kubernetes.podTemplate(
      volumes=[nfs.asFarmMount('jenkins-data')],
      containers=[masterContainer],
      metadata=metadata
    );

    local deployment = kubernetes.deployment(replicas=1, podTemplate=podTemplate, metadata=metadata);

    local service = kubernetes.service(name='jenkins', port=8080, metadata=metadata);

    [deployment, service]
  ),
};

local hub = {
  baseMetadata:: {
    name: 'hub',
    labels: {
      build: BUILD,
    },
  },

  proxyMetadata: self.baseMetadata {
    labels+: {
      service: 'hub-proxy',
    },
  },

  webMetadata: self.baseMetadata {
    labels+: {
      service: 'hub-web',
    },
  },

  dbMetadata: self.baseMetadata {
    labels+: {
      service: 'hub-db',
    },
  },

  asKubeConfig():: (
    []
  ),
};

local kubeApplyScript = {
  autoApply: [
    'ingress',
    'vault',
    'hub',
    'chorebot',
  ],
  asScript():: (
    std.join('\n', ['kubectl apply -f kubernetes/%s.yml' % file for file in self.autoApply])
  ),
};

{
  'docker/docker-compose.yml': std.manifestYamlDoc(docker.asComposeFile()),
  'kubernetes/chorebot.yml': std.manifestYamlStream(chorebot.asKubeConfig()),
  'kubernetes/hub.yml': std.manifestYamlStream(hub.asKubeConfig()),
  'kubernetes/ingress.yml': std.manifestYamlStream(ingress.asKubeConfig()),
  'scripts/kubeApply.sh': kubeApplyScript.asScript(),
}
