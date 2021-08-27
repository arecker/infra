local Hosts = import 'hosts.jsonnet';

local Playbook(name='', tasks=[]) = {
  name: name,
  tasks: tasks,
};

local playbook = Playbook('console', tasks=[]);

local export() = std.manifestYamlDoc(playbook);

{
  export:: export,
}
