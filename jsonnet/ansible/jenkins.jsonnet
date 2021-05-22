local a = import 'lib/ansible.libsonnet';

local tasks = [
  a.packages([
    'default-jdk',
    'git',
    'gnupg2',
    'python3',
    'python3-pip',
    'wget',
  ]),
  a.aptKey(url='https://pkg.jenkins.io/debian/jenkins.io.key'),
  a.template(name='jenkins.list.j2', dest='/etc/apt/sources.list.d/jenkins.list', become=true, mode='0744'),
  a.template(name='jenkins.env.j2', dest='/etc/default/jenkins', become=true, mode='0644'),
  a.package(name='jenkins', update=true),
  a.service(name='jenkins', scope='system'),
];

{
  'ansible/jenkins.yml': std.manifestYamlStream([self.asPlaybook()]),
  asPlaybook():: [
    {
      name: 'jenkins server',
      hosts: 'jenkins.local',
      vars_files: 'secrets/secrets.yml',
      tasks: tasks,
    },
  ],
}
