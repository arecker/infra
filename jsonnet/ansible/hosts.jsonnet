local Host = {
  ansible_ssh_user: 'alex',
  ansible_become_pass: '{{ secrets.sudo }}',
  ansible_python_interpreter: '/usr/bin/python3',
};

{
  all: {
    hosts: {
      'chores.local': Host,
      'wallpaper.local': Host,
      'console.local': Host,
      'diningroom.local': Host {
        ansible_ssh_user: 'recker',
        ansible_become_pass: '{{ secrets.diningroom.sudo }}',
      },
      'minecraft.local': Host,
      'printer.local': Host,
      'jenkins.local': Host,
    },
  },
}
