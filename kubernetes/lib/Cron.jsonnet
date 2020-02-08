local new(name='', schedule='', volumes={}, containers=[], metadata={}, restartPolicy='') = (
  local volumeNames = std.objectFields(volumes);
  {
    apiVersion: 'batch/v1beta1',
    kind: 'CronJob',
    spec: {
      schedule: schedule,
      jobTemplate: {
        spec: {
          template: {
            spec: {
              restartPolicy: restartPolicy,
              volumes: [{ name: k } + volumes[k] for k in volumeNames],
              containers: containers,
            },
          },
        },
      },
    },
  } + { metadata: metadata }
);

{ new:: new }
