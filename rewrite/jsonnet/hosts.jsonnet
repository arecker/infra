local Export = import 'lib/export.jsonnet';

local Host() = {
  user: 'alex',
  ansible_become_pass: '{{ secrets.sudo }}',
  ansible_python_interpreter: '/usr/bin/python3',
};

local hosts = {
  'chores.local': Host(),
  'console.local': Host(),
  'jenkins.local': Host(),
  'minecraft.local': Host(),
  'printer.local': Host(),
  'wallpaper.local': Host(),
  all():: (
    [key for key in std.objectFields(self) if std.endsWith(key, '.local')]
  ),
  export():: (
    local me = self;
    Export.asYamlDoc({
      all: {
        hosts: { [hostname]: hosts[hostname] for hostname in me.all() },
      },
    })
  ),
};

hosts
