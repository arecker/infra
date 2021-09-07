local Hosts = import 'hosts.jsonnet';
local AptKey = import 'lib/aptkey.jsonnet';
local Package = import 'lib/package.jsonnet';
local Playbook = import 'lib/playbook.jsonnet';
local Template = import 'lib/template.jsonnet';

local tasks = [
  Package(name='gnupg2'),
  Template(name='sources.list.j2', dest='/etc/apt/sources.list', variables={ ansible: true, jenkins: true }, become=true, mode='644', owner='root', group='root'),
  AptKey(url='https://pkg.jenkins.io/debian/jenkins.io.key'),
  AptKey(keyserver='keyserver.ubuntu.com', id='93C4A3FD7BB9C367'),
  Package(name='ansible', update=true),
];

Playbook('apt', hosts=Hosts.all(), tasks=tasks)
