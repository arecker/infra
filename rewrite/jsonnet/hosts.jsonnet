local Export = import 'lib/export.jsonnet';
local Host = import 'lib/host.jsonnet';

local hosts = {
  'console.local': Host(),
};

local toAnsible(hosts) = {
  all: {
    hosts: {
      [hostname]: hosts[hostname]
      for hostname in std.objectFields(hosts)
    },
  },
};

{
  hosts:: hosts,
  export():: (
    Export.asYamlDoc(toAnsible(hosts))
  ),
}
