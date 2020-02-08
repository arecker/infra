local Container = import 'lib/Container.jsonnet';
local Cron = import 'lib/Cron.jsonnet';
local Ingress = import 'lib/Ingress.jsonnet';

local metadata = {
  name: 'farm',
};


[
  Ingress.new(
    metadata=metadata,
    rules=[
      { serviceName: 'hub', servicePort: 80 },
      { serviceName: 'vault', servicePort: 8200 },
    ],
  ),

  Cron.new(
    name='chorebot',
    metadata=metadata,
    schedule='0 10 * * *',
    restartPolicy='OnFailure',
    volumes={
      secrets: { emptyDir: {} },
    },
    containers=[
      Container.new(
        name='script',
        image='arecker/chorebot:latest',
        roVolumes={
          secrets: '/secrets',
        }
      ),
      Container.new(
        name='secrets',
        image='arecker/secretboi:latest',
        env={
          VAULT_ADDR: 'http://vault.local',
          VAULT_ROLE: 'chorebot',
          ONLY_RUN_ONCE: 'true',
          SECRET_WEBHOOK: '/slack/reckerfamily/webhook',
        },
        volumes={
          secrets: '/secrets',
        }
      ),
    ]
  ),
]
