local dev = import './dev.jsonnet';
local hosts = import './hosts.jsonnet';

{
  'ansible/hosts.yml': std.manifestYamlStream([hosts]),
  'ansible/dev.yml': std.manifestYamlStream([dev]),
}
