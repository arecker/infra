local PlayBook(name='', tasks=[], hosts='') = (
  assert name != '' : '"name" required!';

  {
    hosts: hosts,
    vars: {
      ansible_user: 'jenkins',
      ansible_python_interpreter: '/usr/bin/python3',
    },
    tasks: tasks,
  }
);

local PublicKey(filename='', user='') = (
  assert filename != '' : '"filename" required!';
  assert user != '' : '"user" required!';

  {
    become: true,
    authorized_key: {
      user: user,
      state: 'present',
      key: std.format("{{ lookup('file', 'keys/%s') }}", filename),
    },
  }
);

local PrivateKey(filename='', target='', user='') = (
  assert filename != '' : '"filename" required!';
  assert target != '' : '"target" required!';
  assert user != '' : '"user" required!';

  {
    become: true,
    copy: {
      src: std.format('keys/%s', filename),
      dest: target,
      state: 'present',
      owner: user,
      group: user,
      mode: '0600',
    },
  }
);

local Packages(names=[]) = (
  {
    become: true,
    package: {
      name: '{{ item }}',
      state: 'present',
    },
    with_items: names,
  }
);

{
  'config.yml': std.manifestYamlDoc([
    // PlayBook(
    //   name='base',
    //   hosts='*.local',
    //   tasks=[
    //     PublicKey(filename='personal.pub', user='alex'),
    //     PublicKey(filename='personal.pub', user='jenkins'),
    //   ],
    // ),
    PlayBook(
      name='jenkins',
      hosts='jenkins.local',
      tasks=[
        PrivateKey(filename='jenkins.priv', target='/var/lib/jenkins/.ssh/id_rsa', user='jenkins'),
        Packages(names=['curl', 'git', 'bash']),
      ],
    ),
  ]),
}
