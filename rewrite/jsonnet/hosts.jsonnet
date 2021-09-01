local Export = import 'lib/export.jsonnet';

local Host(hostname='', user='alex') = {
  user: user,
  hostname: hostname,
};

local toAnsible(host) = {
  ansible_ssh_user: host.user,
  ansible_become_pass: '{{ secrets.sudo }}',
  ansible_python_interpreter: '/usr/bin/python3',
};

{
  console:: Host('console.local'),
  hosts:: [self.console],
  export():: (
    local me = self;
    Export.asYamlDoc({
      all: {
        hosts: { [host.hostname]: toAnsible(host) for host in me.hosts },
      },
    })
  ),
}
