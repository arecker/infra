local a = import 'lib/ansible.libsonnet';

local tasks = [
  a.template(
    name='authorized_keys.j2',
    dest='~/.ssh/authorized_keys',
    variables={
      public_keys: [
        '{{ secrets.public }}',
        '{{ secrets.jenkins.public }}',
      ],
    }
  ),
];

{
  'ansible/ssh.yml': std.manifestYamlStream([self.asPlaybook()]),
  asPlaybook():: [
    {
      name: 'SSH keys',
      hosts: [
        'diningroom.local',
        'minecraft.local',
        'printer.local',
        'prod',
      ],
      vars_files: 'secrets/secrets.yml',
      tasks: tasks,
    },
  ],
}
