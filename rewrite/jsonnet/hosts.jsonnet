local Host() = {
    ansible_become_pass: '{{ secrets.sudo }}',
    ansible_python_interpreter: '/usr/bin/python3',
    ansible_ssh_user: 'alex',
};


local hosts = {
  ['console.local']: Host(),
};

local toAnsible(hosts) = {
  all: {
    hosts: {
      [hostname]: hosts[hostname]
      for hostname in std.objectFields(hosts)
    },
  },
};

local export() = std.manifestYamlDoc(toAnsible(hosts));

{
  hosts:: hosts,
  export:: export
}
