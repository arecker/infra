local Host() = {
  ansible_become_pass: '{{ secrets.sudo }}',
  ansible_python_interpreter: '/usr/bin/python3',
  ansible_ssh_user: 'alex',
};

Host
