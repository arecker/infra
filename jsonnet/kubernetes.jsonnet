{
  _base:: {
    withLabels(labels):: (
      self + { metadata+: { labels+: labels } }
    ),
  },
  ingress():: (
    {
      apiVersion: 'networking.k8s.io/v1beta1',
      kind: 'Ingress',
      spec: {
        rules: [

        ],
      },
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
}
