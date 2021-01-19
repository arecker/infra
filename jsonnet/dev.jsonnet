local a = import 'lib/ansible.libsonnet';

local tasks = [
  a.packages([
    'git',
    'nfs-common',
    'python3',
    'python3-pip',
    'python3-setuptools',
    'python3-venv',
  ]),
  a.directories([
    '~/bin',
    '~/envs',
    '~/mnt',
    '~/src',
    '~/venvs',
  ]),
  a.bins([
    'chorebot',
    'chores',
  ]),
  a.mount(url='nas.local:/volume1/dev', path='/home/alex/mnt'),
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
];

[
  {
    name: 'dev server',
    hosts: 'dev.local',
    remote_user: 'alex',
    vars_files: 'secrets.yml',
    tasks: tasks,
  },
]
