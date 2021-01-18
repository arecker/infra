local a = import 'lib/ansible.libsonnet';

local directory(path) = {
  name: 'directory: ' + path,
  file: {
    path: path,
    state: 'directory',
    mode: '0751',
  },
};

local directories(paths=[]) = directory(path='{{ item }}') {
  with_items: paths,
};

local git(url='', dest='', version='master') = {
  name: 'git: ' + dest,
  git: {
    repo: url,
    dest: dest,
    version: version,
  },
};

local gitPersonal(repo='', dest='', version='master') = (
  local url = 'https://www.github.com/arecker/' + repo + '.git';
  git(url=url, dest=dest, version=version)
);

local venv(name, requirements='') = {
  name: 'venv: ' + name,
  pip: {
    requirements: requirements,
    virtualenv: '~/venvs/' + name,
    virtualenv_command: 'pyvenv',
  },
};

local cron(command='', minute='', hour='') = {
  name: 'cron: ' + command,
  cron: {
    job: command,
    hour: hour,
    minute: minute,
  },
};

local tasks = [
  a.packages([
    'git',
    'python3',
    'python3-pip',
    'python3-setuptools',
    'python3-venv',
  ]),
  directories(['~/src', '~/venvs']),
  gitPersonal(repo='chores', dest='~/src/chores'),
  venv('chores', requirements='~/src/chores/requirements.txt'),
];

[
  {
    name: 'dev server',
    hosts: 'dev.local',
    remote_user: 'alex',
    tasks: tasks,
  },
]
