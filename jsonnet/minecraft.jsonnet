local a = import 'lib/ansible.libsonnet';

local serverJarURL = 'https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar';

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

{
  'ansible/minecraft.yml': std.manifestYamlStream([self.asPlaybook()]),
  asPlaybook():: [
    {
      name: 'minecraft server',
      hosts: 'minecraft.local',
      vars_files: 'secrets/secrets.yml',
      tasks: tasks,
    },
  ],
}
