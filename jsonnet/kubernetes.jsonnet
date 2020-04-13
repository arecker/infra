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
    withVolumeMounts(volumeMounts):: self { volumeMounts: volumeMounts },
  },
  containerEnvList(envMap):: std.sort([
    { name: k, value: envMap[k] }
    for k in std.objectFields(envMap)
  ], keyF=function(x) x.name),
  containerPort(containerPort, protocol='TCP'):: {
    containerPort: containerPort,
    protocol: protocol,
  },
  containerVolumeMount(name, path, readOnly=true):: {
    name: name,
    mountPath: path,
    readOnly: readOnly,
  },
  deployment(name):: self._base {
    apiVersion: 'apps/v1beta1',
    kind: 'Deployment',
    metadata: { name: name },
    withContainers(containers):: self {
      spec+: {
        template+: {
          spec+: {
            containers: containers,
          },
        },
      },
    },
    withReplicas(n):: self { spec+: { replicas: n } },
    withSecurityContext(securityContext):: self {
      spec+: {
        template+: {
          spec+: {
            securityContext: securityContext,
          },
        },
      },
    },
  },
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
}
