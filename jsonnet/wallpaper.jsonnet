local a = import 'lib/ansible.libsonnet';

local port = 5001;

local appHandler = a.serviceHandler(name='wallpaper');
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
  a.directories(paths=['~/bin', '~/wallpaper', '~/src/', '~/envs', '~/venvs', '~/.config/systemd/user']),

  // Provision scripts
  a.bins([
    'sync',
    'wallpaper',
  ]) + { notify: [appHandler.name] },

  // Clone source
  a.gitPersonal(repo='wallpaper', dest='~/src/wallpaper') + { notify: [appHandler.name] },

  // Provision runtime environment
  a.venv('wallpaper', requirements='~/src/wallpaper/requirements.txt') + { notify: [appHandler.name] },
  a.template('env.j2', '~/envs/wallpaper.env', variables={
    FLASK_APP: 'app.py',
    FLASK_ENV: 'production',
    GPHOTOS_COMMAND_PATH: '$HOME/venvs/wallpaper/bin/gphotos-sync',
    PORT: port,
    SECRET_PATH: '$HOME/.wallpaper.json',
    STORAGE_PATH: '$HOME/wallpaper',
  }) + { notify: [appHandler.name] },

  // Setup service
  a.serviceDefinition(
    name='wallpaper',
    command='%h/bin/wallpaper',
    envFile='%h/envs/wallpaper.env',
  ) + { notify: [appHandler.name] },
  a.service(name='wallpaper'),

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

{
  'ansible/wallpaper.yml': std.manifestYamlStream([self.asPlaybook()]),
  hostname:: 'wallpaper.local',
  port:: port,
  asPlaybook():: [
    {
      name: 'wallpaper',
      hosts: 'wallpaper.local',
      vars_files: 'secrets/secrets.yml',
      tasks: tasks,
      handlers: [appHandler, proxyHandler],
    },
  ],
}
