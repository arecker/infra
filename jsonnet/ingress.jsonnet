local hub = import 'hub.jsonnet';
local k = import 'kubernetes.jsonnet';
local vault = import 'vault.jsonnet';

{
  namespace:: k.namespace('ingress'),
  rules:: [
    hub.ingressRule,
    vault.ingressRule,
  ],
  ingress:: (
    k.ingress('ingress').inNamespace('ingress').withRules(self.rules)
  ),
  [k.path('ingress.json')]: k.render(
    k.list([self.namespace, self.ingress])
  ),
}
