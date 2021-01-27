local a = import 'lib/ansible.libsonnet';

local port = 5000;

local serviceHandler = a.serviceHandler(name='chores');

local tasks = [
  a.bins([
    'chorebot',
    'chores',
  ]) + { notify: [serviceHandler.name] },
  a.gitPersonal(repo='chores', dest='~/src/chores') + { notify: [serviceHandler.name] },
  a.venv('chores', requirements='~/src/chores/requirements.txt') + { notify: [serviceHandler.name] },
  a.template('env.j2', '~/envs/chores.env', variables={
    DB_PATH: 'sqlite:////home/alex/mnt/chores.db',
    FLASK_ENV: 'production',
    HUB_URL: 'http://chores.local',
    PORT: port,
    PYTHONDONTWRITEBYTECODE: '1',
    PYTHONUNBUFFERED: '1',
    WEBHOOK_URL: '{{ secrets.chores_webhook_url }}',
  }) + { notify: [serviceHandler.name] },
  a.serviceDefinition(
    name='chores',
    command='%h/bin/chores',
    envFile='%h/envs/chores.env',
  ) + { notify: [serviceHandler.name] },
  a.service(name='chores'),
];

{
  hostname:: 'chores.local',
  port:: port,
  asPlaybook():: [
    {
      name: 'chores',
      hosts: 'dev.local',
      vars_files: 'secrets/secrets.yml',
      tasks: tasks,
      handlers: [serviceHandler],
    },
  ]
}
