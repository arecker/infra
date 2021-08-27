local Hosts = import 'hosts.jsonnet';
local Export = import 'lib/export.jsonnet';
local Playbook = import 'lib/playbook.jsonnet';
local Tasks = import 'lib/tasks.jsonnet';

local playbook = Playbook('console', tasks=[]);

{
  export():: (
    Export.asYamlDoc(playbook)
  ),
}
