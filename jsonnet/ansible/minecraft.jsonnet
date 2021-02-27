local a = import 'lib/ansible.libsonnet';

local serverJarURL = 'https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar';

local tasks = [
  a.directory(path='~/minecraft'),
  a.getUrl(url=serverJarURL, path='~/minecraft/server.jar'),
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
