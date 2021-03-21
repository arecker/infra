local a = import 'lib/ansible.libsonnet';

local tasks = [
  a.packages(names=[
    'ncurses-term',
    'fail2ban',
    'htop',
  ]),
  a.service(name='fail2ban', scope='system'),
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
