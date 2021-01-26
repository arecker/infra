local chores = import 'chores.jsonnet';
local a = import 'lib/ansible.libsonnet';
local wallpaper = import 'wallpaper.jsonnet';

local serviceHandler = a.serviceHandler(name='nginx', scope='system', state='reloaded');

local hosts = {
  [chores.hostname]: chores.port,
  [wallpaper.hostname]: wallpaper.port,
};

local tasks = [
  a.template(
    name='hosts.j2',
    dest='/etc/hosts',
    become=true,
    variables=hosts,
    mode='0644',
  ),
  a.packages([
    'git',
    'nfs-common',
    'nginx',
    'python3',
    'python3-pip',
    'python3-setuptools',
    'python3-venv',
  ]),
  a.directories([
    '~/.config/systemd/user/',
    '~/bin',
    '~/envs',
    '~/src',
    '~/venvs',
  ]),
  a.template(
    name='nginx.conf.j2',
    dest='/etc/nginx/nginx.conf',
    become=true,
    variables=hosts,
  ) + { notify: [serviceHandler.name] },
  a.service(name='nginx', scope='system'),
];

[
  {
    name: 'dev server',
    hosts: 'dev.local',
    remote_user: 'alex',
    tasks: tasks,
    handlers: [serviceHandler],
  },
]
