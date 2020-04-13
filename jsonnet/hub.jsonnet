local k = import 'kubernetes.jsonnet';

{
  [k.path('hub.json')]: k.render(k.list(self.resources)),
  ingress:: k.ingress('hub').inNamespace('hub').withRules([self.ingressRule]),
  ingressRule:: k.ingressRule('hub', 80),
  namespace:: k.namespace('hub'),
  resources:: [self.namespace, self.ingress, self.webService],
  webService:: k.service('hub-web').inNamespace('hub').withPorts(self.webServicePorts),
  webServicePorts:: [k.servicePort(8000)],
}
