local a = import 'lib/ansible.libsonnet';

local tasks = [
  a.template(
    name='hosts.prod.j2',
    dest='/etc/hosts',
    become=true,
    mode='0644',
  ),
  a.packages(names=[
    'fail2ban',
    'htop',
    'logwatch',
    'ncurses-term',
  ]),
  a.service(name='fail2ban', scope='system'),
  a.package(name='mariadb-server'),
];

{
  'ansible/prod.yml': std.manifestYamlStream([self.asPlaybook()]),
  asPlaybook():: [
    {
      name: 'prod server',
      hosts: 'prod',
      vars_files: 'secrets/secrets.yml',
      tasks: tasks,
    },
  ],
}
