local a = import '../ansible.libsonnet';

local restartSSH = a.serviceHandler(
  name='ssh', scope='system', state='restarted',
);
local restartFail2Ban = a.serviceHandler(
  name='fail2ban', scope='system', state='restarted',
);

local tasks = [
  // locale
  a.locale('en_US.UTF-8'),

  // SSH
  a.template(
    name='sshd_config.j2',
    dest='/etc/ssh/sshd_config',
    become=true,
    mode='644',
    owner='root',
    group='root'
  ) + { notify: [restartSSH.name] },
  a.template(
    name='authorized_keys.j2',
    dest='~/.ssh/authorized_keys',
    variables={
      public_keys: [
	'{{ secrets.public }}',
	'{{ secrets.jenkins.public }}',
      ],
    }
  ),

  // Fail2Ban
  a.package('fail2ban'),
  a.template(
    name='fail2ban.conf.j2',
    dest='/etc/fail2ban/fail2ban.conf',
    become=true,
    mode='644',
    owner='root',
    group='root'
  ) + { notify: [restartFail2Ban.name] },

  // Logwatch
  a.package('logwatch'),

  // Shell env
  a.template(
    name='file.j2',
    dest='~/.profile',
    variables={
      content: '',
    },
  ),
  a.template(
    name='bashrc.j2',
    dest='~/.bashrc',
  ),

];

[
  {
    name: 'base configuration',
    hosts: 'all',
    vars_files: 'secrets/secrets.yml',
    tasks: tasks,
    handlers: [restartSSH, restartFail2Ban],
  },
]
