local chores = import './chores.jsonnet';
local dev = import './dev.jsonnet';
local hosts = import './hosts.jsonnet';
local jenkins = import './jenkins.jsonnet';
local wallpaper = import './wallpaper.jsonnet';

{
  'ansible/chores.yml': std.manifestYamlStream([chores.asPlaybook()]),
  'ansible/dev.yml': std.manifestYamlStream([dev]),
  'ansible/hosts.yml': std.manifestYamlStream([hosts]),
  'ansible/jenkins.yml': std.manifestYamlStream([jenkins.asPlaybook()]),
  'ansible/wallpaper.yml': std.manifestYamlStream([wallpaper.asPlaybook()]),
}
