local IngressRule(serviceName='', servicePort) = (
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
);

local new(rules=[], metadata={}) = (
  {
    apiVersion: 'networking.k8s.io/v1beta1',
    kind: 'Ingress',
    spec: {
      rules: [
        IngressRule(
          serviceName=rule.serviceName,
          servicePort=rule.servicePort
        ),
	for rule in rules
      ],
    },
  } + { metadata: metadata }
);

{ new:: new }
