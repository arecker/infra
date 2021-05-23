local a = import 'lib/ansible.libsonnet';

local tasks = [
  {
    name: 'update',
    become: true,
    apt: {
      update_cache: true,
    },
  },
  {
    name: 'upgrade',
    become: true,
    apt: {
      name: '*',
      state: 'latest',
    },
  },
  {
    name: 'dist-upgrade',
    become: true,
    apt: {
      upgrade: 'dist',
    },
  },
  {
    name: 'autoremove',
    become: true,
    apt: {
      autoremove: true,
    },
  },
  {
    name: 'reboot',
    become: true,
    reboot: {
      reboot_timeout: 3600,
    },
  },
];

{
  'ansible/patching.yml': std.manifestYamlStream([self.asPlaybook()]),
  asPlaybook():: [
    {
      name: 'server patching',
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
