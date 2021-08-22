local a = import '../ansible.libsonnet';

local restartSSH = a.serviceHandler(
  name='ssh', scope='system', state='restarted',
);

local tasks = [
  a.template(
    name='sshd_config.j2',
    dest='/etc/ssh/sshd_config',
    become=true, mode='644', owner='root', group='root'
  ) + { notify: [restartSSH.name]},
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
    handlers: [restartSSH]
  },
]
