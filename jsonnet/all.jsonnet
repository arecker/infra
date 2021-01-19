local chores = import './chores.jsonnet';
local dev = import './dev.jsonnet';
local hosts = import './hosts.jsonnet';

{
  'ansible/hosts.yml': std.manifestYamlStream([hosts]),
  'ansible/dev.yml': std.manifestYamlStream([dev]),
  'ansible/chores.yml': std.manifestYamlStream([chores]),
}
