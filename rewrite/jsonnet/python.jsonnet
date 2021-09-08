local Hosts = import 'hosts.jsonnet';
local AuthorizedKeys = import 'lib/authorized_keys.jsonnet';
local Package = import 'lib/package.jsonnet';
local Playbook = import 'lib/playbook.jsonnet';
local Template = import 'lib/template.jsonnet';

local pyenvPackages = [
  'build-essential',
  'curl',
  'libbz2-dev',
  'libffi-dev',
  'liblzma-dev',
  'libncurses5-dev',
  'libncursesw5-dev',
  'libreadline-dev',
  'libsqlite3-dev',
  'libssl-dev',
  'llvm',
  'make',
  'tk-dev',
  'wget',
  'xz-utils',
  'zlib1g-dev',
];

local tasks = [Package(name=package) for package in pyenvPackages] + [
  Package(name='git'),
];

Playbook('python', hosts=Hosts.python(), tasks=tasks)
