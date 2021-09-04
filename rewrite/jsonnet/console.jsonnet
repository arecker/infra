local Hosts = import 'hosts.jsonnet';
local AuthorizedKeys = import 'lib/authorized_keys.jsonnet';
local Package = import 'lib/package.jsonnet';
local Playbook = import 'lib/playbook.jsonnet';
local Template = import 'lib/template.jsonnet';

local tasks = [
  Package(name='openssh-server'),
  Template(name='sshd.conf.j2', dest='/etc/ssh/sshd_config', become=true, mode='644', owner='root', group='root'),
  AuthorizedKeys(user='alex', keys=['personal', 'jenkins']),
];

Playbook('console', hosts=[Hosts.console.hostname], tasks=tasks)
