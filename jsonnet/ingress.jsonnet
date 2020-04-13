local k = import 'kubernetes.jsonnet';

{
  namespace:: k.namespace('ingress'),
  rules:: [
    k.ingressRule('hub', 80),
    k.ingressRule('vault', 8200),
  ],
  ingress:: (
    k.ingress().withRules(self.rules)
  ),
  [k.path('ingress.json')]: k.render(
    k.list([self.namespace, self.ingress])
  ),
}
