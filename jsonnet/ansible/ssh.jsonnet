local a = import '../ansible.libsonnet';

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

[
  {
    name: 'SSH keys',
    hosts: [
      'console.local',
      'diningroom.local',
      'minecraft.local',
      'printer.local',
      'chores.local',
      'wallpaper.local',
    ],
    vars_files: 'secrets/secrets.yml',
    tasks: tasks,
  },
]
