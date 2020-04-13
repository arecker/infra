{
  _base:: {
    withLabels(labels):: (
      self + { metadata+: { labels+: labels } }
    ),
    inNamespace(name):: (
      self + { metadata+: { namespace: name } }
    ),
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
