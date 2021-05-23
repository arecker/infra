{
  'ansible/hosts.yml': std.manifestYamlStream([{
    all: {
      hosts: {
        'chores.local': {
          ansible_ssh_user: 'alex',
          ansible_become_pass: '{{ secrets.sudo }}',
          ansible_python_interpreter: '/usr/bin/python3'
        },
        'wallpaper.local': {
          ansible_ssh_user: 'alex',
          ansible_become_pass: '{{ secrets.sudo }}',
          ansible_python_interpreter: '/usr/bin/python3'
        },
        'dev.local': {
          ansible_ssh_user: 'alex',
          ansible_become_pass: '{{ secrets.sudo }}',
          ansible_python_interpreter: '/usr/bin/python3'
        },
        'diningroom.local': {
          ansible_ssh_user: 'recker',
          ansible_become_pass: '{{ secrets.diningroom.sudo }}',
          ansible_python_interpreter: '/usr/bin/python3'
        },
        'minecraft.local': {
          ansible_ssh_user: 'alex',
          ansible_become_pass: '{{ secrets.sudo }}',
          ansible_python_interpreter: '/usr/bin/python3'
        },
        'printer.local': {
          ansible_ssh_user: 'alex',
          ansible_become_pass: '{{ secrets.sudo }}',
          ansible_python_interpreter: '/usr/bin/python3'
        },
        'prod': {
          ansible_ssh_user: 'alex',
          ansible_become_pass: '{{ secrets.sudo }}',
          ansible_python_interpreter: '/usr/bin/python3'
        },
        'jenkins.local': {
          ansible_ssh_user: 'alex',
          ansible_become_pass: '{{ secrets.sudo }}',
          ansible_python_interpreter: '/usr/bin/python3'
        },
      },
    },
  }]),
}
