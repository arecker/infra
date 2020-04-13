local k = import 'kubernetes.jsonnet';

{
  ingressRule:: k.ingressRule('hub', 80),
}
