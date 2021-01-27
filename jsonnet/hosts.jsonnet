{
  'ansible/hosts.yml': std.manifestYamlStream([{
    all: {
      hosts: {
        'dev.local': {
          ansible_ssh_user: 'alex',
          ansible_become_pass: '{{ secrets.sudo }}',
        },
      },
    },
  }]),
}
