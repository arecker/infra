local Export = import 'export.jsonnet';

local Playbook(name='', hosts=[], tasks=[], secrets_file='secrets/secrets.yml') = {
  name: name,
  tasks: tasks,
  hosts: hosts,
  vars_files: [secrets_file],
  export():: Export.asYamlDoc([self])
};

Playbook
