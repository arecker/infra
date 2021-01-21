local a = import 'lib/ansible.libsonnet';

local handlers = [
  {
    name: 'restart chores service',
    systemd: {
      name: 'chores',
      state: 'restarted',
      scope: 'user',
      daemon_reload: true,
    },
  },
];

local tasks = [
  a.bins([
    'chorebot',
    'chores',
  ]) + { notify: ['restart chores service'] },
  a.gitPersonal(repo='chores', dest='~/src/chores') + { notify: ['restart chores service'] },
  a.venv('chores', requirements='~/src/chores/requirements.txt') + { notify: ['restart chores service'] },
  a.template('env.j2', '~/envs/chores.env', variables={
    DB_PATH: 'sqlite:////home/alex/mnt/chores.db',
    FLASK_ENV: 'production',
    HUB_URL: 'http://chores.local',
    PYTHONDONTWRITEBYTECODE: '1',
    PYTHONUNBUFFERED: '1',
    WEBHOOK_URL: '{{ secrets.chores_webhook_url }}',
  }) + { notify: ['restart chores service'] },
  a.cron(
    name='chorebot',
    minute='0',
    hour='10',
    command='$HOME/bin/chorebot &> /dev/null'
  ),
  a.serviceDefinition(
    name='chores',
    command='%h/bin/chores',
    envFile='%h/envs/chores.env',
  ) + { notify: ['restart chores service'] },
  a.service(name='chores'),
];

[
  {
    name: 'chores',
    hosts: 'dev.local',
    remote_user: 'alex',
    vars_files: 'secrets.yml',
    tasks: tasks,
    handlers: handlers,
  },
]
