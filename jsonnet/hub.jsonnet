local docker = import 'docker.jsonnet';
local k = import 'kubernetes.jsonnet';

local ingress = {
  resources:: [k.ingress('hub').inNamespace('hub').withRules(self.rules)],
  rules:: [k.ingressRule('hub', 80)],
};

local db = {
  initContainers: [
    k
    .container('postgres')
    .withImage('busybox')
    .withImagePullPolicy('Always')
    .withVolumeMounts([k.containerVolumeMount('db', '/data')]),
  ],
  containers: [
    k
    .container('postgres')
    .withImage('postgres:11.5')
    .withImagePullPolicy('Always')
    .withEnv(self.containerEnv)
    .withPorts(self.containerPorts),
  ],
  containerEnv: k.containerEnvList({
    PGDATA: '/var/lib/postgresql/data/pgdata',
    POSTGRES_DB: 'hub',
    POSTGRES_USER_FILE: '/secrets/HUB/db_username',
    POSTGRES_PASSWORD_FILE: '/secrets/HUB/db_password',
  }),
  containerPorts: [k.containerPort(5432)],
  deployment: (
    k
    .deployment('hub-db')
    .inNamespace('hub')
    .withReplicas(1)
    .withContainers(self.containers)
    .withInitContainers(self.initContainers)
    .withSecurityContext(self.securityContext)
    .withSecrets(
      role='hub',
      once=true,
      recurse=true,
      paths={
        HUB: '/hub',
      },
    )
  ),
  resources: [self.service, self.deployment],
  securityContext: k.securityContext(1000, 1000),
  service: (
    k
    .service('hub-db')
    .inNamespace('hub')
    .withPorts(self.servicePorts)
  ),
  servicePorts: [k.servicePort(5432)],
  volumes: [
    k.volumeFromArchive('db', '/hub/media'),
  ],
};

local web = {
  container: (
    k
    .container('web')
    .withImage(docker.projects['hub-web'].image)
    .withImagePullPolicy('Always')
    .withEnv(self.containerEnv)
    .withPorts(self.containerPorts)
    .withVolumeMounts(self.containerVolumeMounts)
  ),
  containerEnv: k.containerEnvList({
    DJANGO_SETTINGS_MODULE: 'hub.settings.prod',
    DEBUG: 'false',
  }),
  containerPorts: [k.containerPort(8000)],
  containerVolumeMounts: [
    k.containerVolumeMount('media', '/media'),
  ],
  deployment: (
    k
    .deployment('hub-web')
    .inNamespace('hub')
    .withReplicas(2)
    .withContainers([self.container])
    .withSecurityContext(self.securityContext)
    .withVolumes(self.volumes)
    .withSecrets(
      role='hub',
      once=true,
      recurse=true,
      paths={
        HUB: '/hub',
      },
    )
  ),
  resources: [self.service, self.deployment],
  securityContext: k.securityContext(1001, 1001),
  service: k.service('hub-web').inNamespace('hub').withPorts(self.servicePorts),
  servicePorts: [k.servicePort(8000)],
  volumes: [
    k.volumeFromArchive('media', '/hub/media'),
  ],
};

{
  [k.path('hub.json')]: k.render(k.list(self.resources)),
  namespace:: k.namespace('hub'),
  resources:: [self.namespace] + ingress.resources + db.resources + web.resources,
}
