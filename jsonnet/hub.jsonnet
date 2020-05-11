local docker = import 'docker.jsonnet';
local k = import 'kubernetes.jsonnet';

local namespace = {
  name: 'hub',
  resources: [k.namespace(self.name)],
};

local db = {
  initContainers: [
    k
    .container('permissions')
    .withImage('busybox')
    .withImagePullPolicy('Always')
    .withVolumeMounts([k.containerVolumeMount('db', '/data')])
    .withCommand(['/bin/chmod', '-R', '777', '/data']),
  ],
  containers: [
    k
    .container('postgres')
    .withImage('postgres:11.5')
    .withImagePullPolicy('Always')
    .withEnv(self.containerEnv)
    .withPorts(self.containerPorts)
    .withVolumeMounts([k.containerVolumeMount('db', '/var/lib/postgresql/data')]),
  ],
  containerEnv: k.containerEnvList({
    PGDATA: '/var/lib/postgresql/data/pgdata',
    POSTGRES_DB: 'hub',
    POSTGRES_USER_FILE: '/secrets/HUB/db_username',
    POSTGRES_PASSWORD_FILE: '/secrets/HUB/db_password',
  }),
  containerPorts: [k.containerPort(5432)],
  deployment: (
    local me = self;
    k
    .deployment('hub-db')
    .inNamespace('hub')
    .withReplicas(1)
    .withPodMetadata({ labels: me.podLabels })
    .withContainers(self.containers)
    .withInitContainers(self.initContainers)
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
  podLabels: (
    local me = self;
    { service: me.serviceName }
  ),
  resources: [self.service, self.deployment],
  securityContext: k.securityContext(1000, 1000),
  service: (
    k
    .service(self.serviceName)
    .inNamespace('hub')
    .withPorts(self.servicePorts)
  ),
  serviceName: 'hub-db',
  servicePorts: [k.servicePort(5432)],
  volumes: [
    k.volumeFromNFS(
      name='db',
      server='archive.local',
      path='/mnt/scratch/hub',
    ),
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
    .withCommand(['./entry.sh'])
    .withArgs(['web'])
  ),
  containerEnv: k.containerEnvList({
    DJANGO_SETTINGS_MODULE: 'hub.settings.prod',
    DEBUG: 'false',
    DB_HOST: 'hub-db.hub.svc.cluster.local',
  }),
  containerPorts: [k.containerPort(8000)],
  containerVolumeMounts: [
    k.containerVolumeMount('media', '/media'),
  ],
  deployment: (
    local me = self;
    k
    .deployment('hub-web')
    .inNamespace('hub')
    .withReplicas(2)
    .withPodMetadata({ labels: me.podLabels })
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
  podLabels: (
    local me = self;
    { service: me.serviceName }
  ),
  resources: [self.service, self.deployment],
  securityContext: k.securityContext(1001, 1001),
  service: k.service(self.serviceName).inNamespace('hub').withPorts(self.servicePorts),
  servicePorts: [k.servicePort(8000)],
  serviceName: 'hub-web',
  volumes: [
    k.volumeFromArchive('media', '/hub/media'),
  ],
};

local proxy = {
  container: (
    k
    .container('proxy')
    .withImage(docker.projects['hub-proxy'].image)
    .withImagePullPolicy('Always')
    .withEnv(self.containerEnv)
    .withPorts(self.containerPorts)
    .withVolumeMounts(self.containerVolumeMounts)
  ),
  containerEnv: k.containerEnvList({
    UPSTREAM_DNS: '%s.%s.svc.cluster.local' % [web.serviceName, namespace.name],
    UPSTREAM_HOSTNAME: 'hub.local',
  }),
  containerPorts: [k.containerPort(80), k.containerPort(443)],
  containerVolumeMounts: [
    k.containerVolumeMount('media', '/usr/share/nginx/html/media/', readOnly=true),
  ],
  deployment: (
    local me = self;
    k
    .deployment('hub-proxy')
    .inNamespace('hub')
    .withReplicas(2)
    .withPodMetadata({ labels: me.podLabels })
    .withContainers([self.container])
    .withVolumes(self.volumes)
  ),
  podLabels: (
    local me = self;
    { service: me.serviceName }
  ),
  resources: [self.service, self.deployment],
  service: k.service(self.serviceName).inNamespace('hub').withPorts(self.servicePorts),
  serviceName: 'hub-proxy',
  servicePorts: [k.servicePort(80)],
  volumes: [
    k.volumeFromArchive('media', '/hub/media'),
  ],
};

local ingress = {
  hostname: 'hub.local',
  resources:: [k.ingress('hub').inNamespace('hub').withRules(self.rules)],
  rules:: [k.ingressRule(self.hostname, proxy.serviceName, 80)],
};

local clusterRoleBinding = {
  apiVersion: 'rbac.authorization.k8s.io/v1beta1',
  kind: 'ClusterRoleBinding',
  metadata: {
    name: 'role-tokenreview-binding',
    namespace: namespace.name,
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'system:auth-delegator',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: 'default',
      namespace: namespace.name,
    },
  ],
};

{
  [k.path('hub.json')]: k.render(k.list(self.resources)),
  resources:: namespace.resources + ingress.resources + db.resources + web.resources + proxy.resources + [clusterRoleBinding],
}
