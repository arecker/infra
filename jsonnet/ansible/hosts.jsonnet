local Host = {
  ansible_ssh_user: 'alex',
  ansible_become_pass: '{{ secrets.sudo }}',
  ansible_python_interpreter: '/usr/bin/python3',
};

{
  all: {
    hosts: {
      'jenkins.local': Host,
      ebonhawk: Host,
    },
  },
}
