local docker = (
  local projects = [
    'chorebot',
    'vault',
  ];
  {
    projects: projects,
    login():: (
      'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
    ),
    compose(cmd):: (
      'docker-compose -f $TRAVIS_BUILD_DIR/docker/docker-compose.yml %s' % cmd
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
  container(name, image, env={}, volumes={}, roVolumes={}, pullPolicy='Always'):: (
    {
      name: name,
      image: image,
      imagePullPolicy: pullPolicy,
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
  addSecretboiInit(info, podTemplate):: (
    local addSecretMount(container) = (
      local mount = { name: 'secrets', mountPath: '/secrets', readOnly: true };
      container {
        volumeMounts: container.volumeMounts + [mount],
      }
    );

    local container = self.container(
      name='secretboi',
      image='arecker/secretboi:latest',
      volumes={ secrets: '/secrets' },
      env={
        VAULT_ADDR: 'http://vault.local',
        VAULT_ROLE: info.role,
        ONLY_RUN_ONCE: '%s' % info.once,
      } + {
        ['SECRET_%s' % k]: info.paths[k]
        for k in std.objectFields(info.paths)
      }
    );
    podTemplate {
      volumes: podTemplate.volumes { secrets: { emptyDir: {} } },
      containers: std.map(addSecretMount, podTemplate.containers) + [container],
    }
  ),
  podTemplate(info, metadata={}):: (
    local containers = [self.container(info.name, info.image)];
    self.addSecretboiInit(info.secrets, {
      restartPolicy: 'OnFailure',
      containers: containers,
      volumes: info.volumes,
    })
  ),
  cron(info, metadata={}):: (
    local podTemplate = self.podTemplate(info, metadata);
    {
      apiVersion: 'batch/v1beta1',
      kind: 'CronJob',
      spec: {
        schedule: info.schedule,
        jobTemplate: { spec: { template: { spec: podTemplate } } },
      },
    } + { metadata: metadata }
  ),
};

local farm = {
  metadata: {
    name: 'farm',
  },
  asKubeConfig():: [
    kubernetes.ingress([
      { serviceName: 'hub', servicePort: 80 },
      { serviceName: 'vault', servicePort: 8200 },
    ], metadata=self.metadata),

    kubernetes.cron({
      name: 'chorebot',
      schedule: '0 10 * * *',
      image: docker.images.chorebot,
      volumes: {},
      secrets: {
        role: 'chorebot',
        once: true,
        paths: {
          WEBHOOK: '/slack/reckerfamily/webhook',
        },
      },
    }),
  ],
};

{
  '.travis.yml': std.manifestYamlDoc(travis.asTravisFile()),
  'docker/docker-compose.yml': std.manifestYamlDoc(docker.asComposeFile()),
  'kubernetes/farm.yml': std.manifestYamlStream(farm.asKubeConfig()),
}
