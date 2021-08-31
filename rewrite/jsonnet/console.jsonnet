local Hosts = import 'hosts.jsonnet';
local Export = import 'lib/export.jsonnet';
local Playbook = import 'lib/playbook.jsonnet';
local Tasks = import 'lib/tasks.jsonnet';

local hosts = ['console.local'];

local tasks = [
  Tasks.setTimezone(),
];

local playbook = Playbook('console', hosts=hosts, tasks=tasks);

{
  export():: (
    Export.asYamlDoc([playbook])
  ),
}
