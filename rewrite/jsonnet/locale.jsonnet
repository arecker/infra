local Hosts = import 'hosts.jsonnet';
local LocaleGen = import 'lib/localegen.jsonnet';
local Package = import 'lib/package.jsonnet';
local Playbook = import 'lib/playbook.jsonnet';

local tasks = [
  Package(name='locales'),
  LocaleGen(),
];

Playbook('locale', hosts=Hosts.all(), tasks=tasks)
