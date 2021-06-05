local a = import '../ansible.libsonnet';

local port = 5000;

local appHandler = a.serviceHandler(name='chores');
local proxyHandler = a.serviceHandler(name='nginx', scope='system', state='reloaded');

local tasks = [
  // Install packages
  a.packages([
    'git',
    'nginx',
    'python3',
    'python3-pip',
    'python3-setuptools',
    'python3-venv',
  ]),

  // Directories
  a.directories(paths=['~/bin', '~/src/', '~/envs', '~/venvs', '~/.config/systemd/user']),

  // Provision scripts
  a.bins([
    'chorebot',
    'chores',
  ]) + { notify: [appHandler.name] },

  // Clone source
  a.gitPersonal(repo='chores', dest='~/src/chores') + { notify: [appHandler.name] },

  // Provision runtime environment
  a.venv('chores', requirements='~/src/chores/requirements.txt') + { notify: [appHandler.name] },
  a.template('env.j2', '~/envs/chores.env', variables={
    DB_PATH: 'sqlite:////home/alex/chores.db',
    FLASK_ENV: 'production',
    HUB_URL: 'http://chores.local',
    PORT: port,
    PYTHONDONTWRITEBYTECODE: '1',
    PYTHONUNBUFFERED: '1',
    WEBHOOK_URL: '{{ secrets.chores_webhook_url }}',
  }) + { notify: [appHandler.name] },

  // Setup service
  a.serviceDefinition(
    name='chores',
    command='%h/bin/chores',
    envFile='%h/envs/chores.env',
  ) + { notify: [appHandler.name] },
  a.service(name='chores'),

  // Setup proxy
  a.template(
    name='nginx/app.conf.j2',
    dest='/etc/nginx/nginx.conf',
    become=true,
    variables={
      port: port,
    },
  ) + { notify: [proxyHandler.name] },
  a.service(name='nginx', scope='system'),
];

[
  {
    name: 'chores',
    hosts: 'chores.local',
    vars_files: 'secrets/secrets.yml',
    tasks: tasks,
    handlers: [appHandler, proxyHandler],
  },
]
