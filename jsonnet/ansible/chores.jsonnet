local a = import '../ansible.libsonnet';

local port = 5000;

local proxyHandler = a.serviceHandler(name='nginx', scope='system', state='reloaded');

local tasks = [
  // Install packages
  a.packages(['git','nginx']),

  // Directories
  a.directories(paths=['~/bin', '~/src/', '~/envs', '~/venvs']),

  // Provision scripts
  a.bins(['chorebot']),

  // Clone source
  a.gitPersonal(repo='chores', dest='~/src/chores'),

  // Env
  a.template('env.j2', '~/envs/chores.env', variables={
    DB_PATH: 'sqlite:////home/alex/chores.db',
    FLASK_ENV: 'production',
    HUB_URL: 'http://chores.local',
    PORT: port,
    PYTHONDONTWRITEBYTECODE: '1',
    PYTHONUNBUFFERED: '1',
    WEBHOOK_URL: '{{ secrets.chores_webhook_url }}',
  }),


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
    handlers: [proxyHandler],
  },
]
