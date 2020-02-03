local exposed_services = [
  { name: 'hub', port: 80 },
  { name: 'vault', port: 8200 },
];

local ingress = {
  apiVersion: 'networking.k8s.io/v1beta1',
  kind: 'Ingress',
  metadata: { name: 'farm-ingress' },
  spec: {
    rules: [
      {
        service: service.name + '.local',
        http: { paths: [{ backend: { serviceName: service.name, servicePport: service.port } }] },
      }
      for service in exposed_services
    ],
  },
};

local CronJob(name, image=null) = (
  {
    name: name,
    image: if image == null then 'arecker/' + name + ':latest' else image
  }
);

// apiVersion: batch/v1beta1
// kind: CronJob
// metadata:
//   name: chorebot
// spec:
//   schedule: "0 10 * * *"
//   jobTemplate:
//     spec:
//       template:
//         spec:
//           restartPolicy: OnFailure
//           containers:
//           - name: script
//             image: arecker/chorebot:latest
//             imagePullPolicy: Always
//             volumeMounts:
//             - mountPath: /run/secrets/chorebot/
//               name: chorebot-secrets
//               readOnly: true
//           volumes:
//             - name: chorebot-secrets
//               secret:
//                 secretName: chorebot


[ingress + CronJob('chorebot')]
