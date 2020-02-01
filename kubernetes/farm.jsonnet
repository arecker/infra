local services = [
  'hub',
  'vault',
]

local ingress = {
  apiVersion: 'networking.k8s.io/v1beta1',
  kind: 'Ingress',
  metadata: { name: 'farm-ingress' },
  spec: {
    rules: []
  }
}

std.manifestYamlStream([ingress])
