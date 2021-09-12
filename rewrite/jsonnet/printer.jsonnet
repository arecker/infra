local Package = import 'lib/package.jsonnet';
local Playbook = import 'lib/playbook.jsonnet';
local Template = import 'lib/template.jsonnet';

local tasks = [
  Package(name='cups'),
  Package(name='avahi-daemon'),
  Template(name='cupsd.conf.j2', dest='/etc/cups/cupsd.conf', become=true, owner='root', group='root', mode='0644'),
];

Playbook('cups', hosts=['printer.local'], tasks=tasks)
