local a = import '../ansible.libsonnet';

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
    shell: 'sleep 5 && reboot',
    async: true,
    poll: false,
  },
  {
    name: 'wait',
    connection: 'local',
    wait_for: {
      port: 22,
      host: '{{ (ansible_ssh_host|default(ansible_host))|default(inventory_hostname) }}',
      search_regex: 'OpenSSH',
      delay: 10,
      timeout: 120,
    },
  },
];

[
  {
    name: 'server patching',
    hosts: [
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
