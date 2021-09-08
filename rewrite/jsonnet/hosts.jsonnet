local Export = import 'lib/export.jsonnet';

local Host(python=false) = {
  python:: python,
  user: 'alex',
  ansible_become_pass: '{{ secrets.sudo }}',
  ansible_python_interpreter: '/usr/bin/python3',
};

local hosts = {
  'chores.local': Host(python=true,),
  'console.local': Host(python=true),
  'jenkins.local': Host(),
  'minecraft.local': Host(),
  'printer.local': Host(),
  'wallpaper.local': Host(python=true),
  all():: (
    [key for key in std.objectFields(self) if std.endsWith(key, '.local')]
  ),
  python():: (
    [key for key in self.all() if self[key].python == true]
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
