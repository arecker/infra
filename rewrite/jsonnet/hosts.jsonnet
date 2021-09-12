local Export = import 'lib/export.jsonnet';

local Host(python=false, apt=true, ssh=true, user='alex', sudo='{{ secrets.sudo }}') = {
  apt:: apt,
  python:: python,
  ssh:: ssh,
  ansible_ssh_user: user,
  ansible_become_pass: sudo,
  ansible_python_interpreter: '/usr/bin/python3',
};

local hosts = {
  'chores.local': Host(python=true,),
  'console.local': Host(python=true),
  'diningroom.local': Host(user='recker', sudo='{{ secrets.diningroom.sudo }}'),
  'jenkins.local': Host(),
  'minecraft.local': Host(),
  'printer.local': Host(apt=false, ssh=false),
  'wallpaper.local': Host(python=true),
  all():: (
    [key for key in std.objectFields(self) if std.endsWith(key, '.local')]
  ),
  apt():: (
    [key for key in self.all() if self[key].apt == true]
  ),
  python():: (
    [key for key in self.all() if self[key].python == true]
  ),
  ssh():: (
    [key for key in self.all() if self[key].ssh == true]
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
