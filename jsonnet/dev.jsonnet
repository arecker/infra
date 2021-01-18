local a = import 'lib/ansible.libsonnet';

local tasks = [
  a.packages([
    'git',
    'python3',
    'python3-pip',
    'python3-setuptools',
    'python3-venv',
  ]),
  a.directories([
    '~/envs',
    '~/src',
    '~/venvs',
  ]),
  a.gitPersonal(repo='chores', dest='~/src/chores'),
  a.venv('chores', requirements='~/src/chores/requirements.txt'),
  a.template('env.j2', '~/envs/chores.env', variables={
    HUB_URL: 'http://chores.local',
    WEBHOOK_URL: '{{ secrets.chores_webhook_url }}',
  }),
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
