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
    '~/.config/systemd/user/',
    '~/bin',
    '~/envs',
    '~/mnt',
    '~/src',
    '~/venvs',
  ]),
  a.mount(url='nas.local:/volume1/dev', path='/home/alex/mnt'),
];

[
  {
    name: 'dev server',
    hosts: 'dev.local',
    remote_user: 'alex',
    tasks: tasks,
  },
]
