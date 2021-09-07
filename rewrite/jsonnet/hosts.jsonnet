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
  chores:: Host('chores.local'),
  wallpaper:: Host('wallpaper.local'),
  printer:: Host('printer.local'),
  jenkins:: Host('jenkins.local'),
  minecraft:: Host('minecraft.local'),
  hosts:: [self.console, self.chores, self.wallpaper, self.jenkins, self.printer, self.minecraft],
  all():: [host.hostname for host in self.hosts],
  export():: (
    local me = self;
    Export.asYamlDoc({
      all: {
        hosts: { [host.hostname]: toAnsible(host) for host in me.hosts },
      },
    })
  ),
}
