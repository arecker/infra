local a = import 'lib/ansible.libsonnet';

local tasks = [
  a.package(name='screen'),
];

{
  'ansible/minecraft.yml': std.manifestYamlStream([self.asPlaybook()]),
  asPlaybook():: [
    {
      name: 'minecraft server',
      hosts: 'dev.local',
      vars_files: 'secrets/secrets.yml',
      tasks: tasks,
    },
  ],
}
