local a = import 'lib/ansible.libsonnet';

local handlers = [
  {
    name: 'reload systemd',
    systemd: {
      daemon_reload: true,
      scope: 'user',
    },
  },
];

local tasks = [
  a.bins([
    'chorebot',
    'chores',
  ]),
  a.gitPersonal(repo='chores', dest='~/src/chores'),
  a.venv('chores', requirements='~/src/chores/requirements.txt'),
  a.template('env.j2', '~/envs/chores.env', variables={
    DB_PATH: 'sqlite:///$HOME/mnt/chores.db',
    FLASK_ENV: 'production',
    HUB_URL: 'http://chores.local',
    PYTHONDONTWRITEBYTECODE: '1',
    PYTHONUNBUFFERED: '1',
    WEBHOOK_URL: '{{ secrets.chores_webhook_url }}',
  }),
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
  ) + {
    notify: 'reload systemd',
  },
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
