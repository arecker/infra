local k = import 'kubernetes.jsonnet';

{
  ingressRule:: k.ingressRule('vault', 8200),
}
