local a = import '../ansible.libsonnet';

local serverJarURL = 'https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar';

local tasks = [
  a.packages([
    'default-jdk',
    'screen',
  ]),
  a.directory(path='~/minecraft'),
  a.directory(path='~/bin'),
  a.directory(path='~/backups'),
  a.getUrl(url=serverJarURL, path='~/minecraft/server.jar'),
  a.bins(names=['minecraft', 'minecraft-backup']),
  a.cronSpecial(name='minecraft server', command='~/bin/minecraft', specialTime='reboot'),
  a.cronSpecial(name='minecraft server backup', command='~/bin/minecraft-backup', specialTime='hourly'),
];

[
  {
    name: 'minecraft server',
    hosts: 'minecraft.local',
    vars_files: 'secrets/secrets.yml',
    tasks: tasks,
  },
]
