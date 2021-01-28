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
  a.template(name='ansible.list.j2', dest='/etc/apt/sources.list.d/ansible.list', become=true, mode='0744'),
  a.aptKey(keyserver='keyserver.ubuntu.com', id='93C4A3FD7BB9C367'),
  a.packages([
    'git',
    'nfs-common',
    'nginx',
    'python3',
    'python3-pip',
    'python3-setuptools',
    'python3-venv',
  ]),
  a.package('ansible', update=true),
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

{
  'ansible/dev.yml': std.manifestYamlStream([self.asPlaybook()]),
  asPlaybook():: [
    {
      name: 'dev server',
      hosts: 'dev.local',
      vars_files: 'secrets/secrets.yml',
      tasks: tasks,
      handlers: [serviceHandler],
    },
  ],
}
