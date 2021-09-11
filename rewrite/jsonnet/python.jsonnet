local Hosts = import 'hosts.jsonnet';
local AuthorizedKeys = import 'lib/authorized_keys.jsonnet';
local Command = import 'lib/command.jsonnet';
local Git = import 'lib/git.jsonnet';
local Package = import 'lib/package.jsonnet';
local Packages = import 'lib/packages.jsonnet';
local Playbook = import 'lib/playbook.jsonnet';
local Template = import 'lib/template.jsonnet';

local PythonVersion = '3.9.7';

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

local tasks = [
  Packages(names=pyenvPackages),
  Package(name='git'),
  Git(url='https://github.com/pyenv/pyenv.git', dest='~/.pyenv'),
  Command(command='~/.pyenv/bin/pyenv install ' + PythonVersion, creates='~/.pyenv/versions/' + PythonVersion)
];

Playbook('python', hosts=Hosts.python(), tasks=tasks)
