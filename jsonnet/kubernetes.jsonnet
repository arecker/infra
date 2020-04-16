{
  _base:: {
    withLabels(labels):: (
      self + { metadata+: { labels+: labels } }
    ),
    inNamespace(name):: (
      self + { metadata+: { namespace: name } }
    ),
  },
  container(name):: {
    name: name,
    withEnv(envList):: self { env: envList },
    withImage(image):: self { image: image },
    withImagePullPolicy(policy):: self { imagePullPolicy: policy },
    withPorts(containerPorts):: self { ports: containerPorts },
    withVolumeMounts(volumeMounts):: self { volumeMounts+: volumeMounts },
  },
  containerEnvList(envMap):: std.sort([
    { name: k, value: envMap[k] }
    for k in std.objectFields(envMap)
  ], keyF=function(x) x.name),
  containerPort(containerPort, protocol='TCP'):: {
    containerPort: containerPort,
    protocol: protocol,
  },
  containerVolumeMount(name, path, readOnly=false):: {
    name: name,
    mountPath: path,
    readOnly: readOnly,
  },
  deployment(name):: (
    local k = self;

    self._base {
      apiVersion: 'apps/v1beta1',
      kind: 'Deployment',
      metadata: { name: name },
      spec: {
        template: {
          spec: {
            initContainers: [],
            containers: [],
            volumes: [],
          },
        },
      },
      withContainers(containers):: self {
        spec+: {
          template+: {
            spec+: {
              containers: containers,
            },
          },
        },
      },
      withInitContainers(initContainers):: self {
        spec+: {
          template+: {
            spec+: {
              initContainers: initContainers,
            },
          },
        },
      },
      withReplicas(n):: self { spec+: { replicas: n } },
      withSecrets(role, paths={}, once=false, recurse=false):: (
        local container =
          k
          .container('secretboi')
          .withImage('arecker/secretboi:latest')
          .withImagePullPolicy('Always')
          .withVolumeMounts(k.containerVolumeMount('secrets', '/secrets'))
          .withEnv(k.containerEnvList({
            VAULT_ADDR: 'http://vault.local',
            VAULT_ROLE: role,
            ONLY_RUN_ONCE: '%s' % once,
            RECURSE_SECRETS: '%s' % recurse,
          } + {
            ['SECRET_%s' % k]: paths[k]
            for k in std.objectFields(paths)
          }));

        local volumeMount = k.containerVolumeMount('secrets', '/secrets', readOnly=true);
        local containers = self.spec.template.spec.containers;
        local initContainers = self.spec.template.spec.initContainers;

        self {
          spec+: {
            template+: {
              spec+: {
                volumes+: [{ name: 'secrets', emptyDir: { medium: 'Memory' } }],
                containers: [
                  c.withVolumeMounts([volumeMount])
                  for c in containers
                ] + if once then [] else [container],
                initContainers: [
                  c.withVolumeMounts([volumeMount])
                  for c in initContainers
                ] + if once then [container] else [],
              },
            },
          },
        }
      ),
      withSecurityContext(securityContext):: self {
        spec+: {
          template+: {
            spec+: {
              securityContext: securityContext,
            },
          },
        },
      },
      withVolumes(volumes):: self {
        spec+: {
          template+: {
            spec+: {
              volumes: volumes,
            },
          },
        },
      },
    }
  ),
  ingress(name):: (
    self._base {
      apiVersion: 'networking.k8s.io/v1beta1',
      kind: 'Ingress',
      metadata: { name: name },
      withRules(ingressRules):: (
        self {
          spec+: {
            rules+: ingressRules,
          },
        }
      ),
    }
  ),
  ingressRule(serviceName, servicePort):: (
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
  ),
  list(items):: (
    {
      apiVersion: 'v1',
      kind: 'List',
      items: items,
    }
  ),
  namespace(name):: (
    self._base {
      apiVersion: 'v1',
      kind: 'Namespace',
      metadata: {
        name: name,
        labels: {
          name: name,
        },
      },
    }
  ),
  path(file):: 'kubernetes/' + file,
  render(data):: std.manifestJson(data),
  securityContext(uid, gid):: { runAsUser: uid, runAsGroup: gid },
  service(name):: self._base {
    name:: name,
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: name,
    },
    spec: {
      selector: {
        service: name,
      },
    },
    withPorts(ports):: self + {
      spec+: { ports+: ports },
    },
  },
  servicePort(port, protocol='TCP'):: { port: port, protocol: protocol },
  volumeFromArchive(name, path):: {
    name: name,
    nfs: {
      server: 'archive.local',
      path: '/mnt/scratch/farm%s' % path,
    },
  },
}
