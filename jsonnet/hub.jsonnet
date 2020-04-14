local k = import 'kubernetes.jsonnet';

local ingress = {
  resources:: [k.ingress('hub').inNamespace('hub').withRules(self.rules)],
  rules:: [k.ingressRule('hub', 80)],
};

local db = {
  container: (
    k
    .container('postgres')
    .withImage('postgres:11.5')
    .withImagePullPolicy('Always')
    .withEnv(self.containerEnv)
    .withPorts(self.containerPorts)
  ),
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
    .withContainers([self.container])
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
};

local web = {
  resources: [self.service],
  service: k.service('hub-web').inNamespace('hub').withPorts(self.servicePorts),
  servicePorts: [k.servicePort(8000)],
};

{
  [k.path('hub.json')]: k.render(k.list(self.resources)),
  namespace:: k.namespace('hub'),
  resources:: [self.namespace] + ingress.resources + db.resources + web.resources,
}
