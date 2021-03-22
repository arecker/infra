local a = import 'lib/ansible.libsonnet';

local apacheHandler = a.serviceHandler(name='apache2', scope='system', state='reloaded');

local reloadApache = { notify: [apacheHandler.name] };

local a2enable(filename) = (
  local src = '/etc/apache2/sites-available/' + filename;
  local dst = '/etc/apache2/sites-enabled/' + filename;
  {
    name: 'symlink: ' + dst,
    become: true,
    file: {
      src: src,
      dest: dst,
      owner: 'root',
      group: 'root',
      state: 'link',
    },
  } + reloadApache
);

local tasks = [
  a.package(name='apache2') + reloadApache,
  a.service(name='apache2', scope='system') + reloadApache,
  a.template(
    name='apache/apache2.conf.j2',
    dest='/etc/apache2/apache2.conf',
    become=true,
    mode='0644'
  ) + reloadApache,
  a.template(
    name='apache/ports.conf.j2',
    dest='/etc/apache2/ports.conf',
    become=true,
    mode='0644'
  ) + reloadApache,
  a.template(
    name='apache/default.html.j2',
    dest='/var/www/html/index.html',
    become=true,
    mode='0644'
  ),
  a.template(
    name='apache/default.conf.j2',
    dest='/etc/apache2/sites-available/000-default.conf',
    become=true,
    mode='0644'
  ) + reloadApache,
  a2enable('000-default.conf'),
];

{
  'ansible/apache.yml': std.manifestYamlStream([self.asPlaybook()]),
  asPlaybook():: [
    {
      name: 'apache',
      hosts: 'prod',
      vars_files: 'secrets/secrets.yml',
      tasks: tasks,
      handlers: [apacheHandler],
    },
  ],
}
