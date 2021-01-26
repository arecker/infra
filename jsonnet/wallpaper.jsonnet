local a = import 'lib/ansible.libsonnet';

local port = 5001;

local serviceHandler = a.serviceHandler(name='wallpaper');

local tasks = [
  a.bins([
    'sync',
    'wallpaper',
  ]) + { notify: [serviceHandler.name] },
  a.gitPersonal(repo='wallpaper', dest='~/src/wallpaper'),
  a.venv('wallpaper', requirements='~/src/wallpaper/requirements.txt'),
  a.copy('credentials.json', '~/.wallpaper.json'),
  a.template('env.j2', '~/envs/wallpaper.env', variables={
    FLASK_APP: 'app.py',
    FLASK_ENV: 'production',
    GPHOTOS_COMMAND_PATH: '$HOME/venvs/wallpaper/bin/gphotos-sync',
    PORT: port,
    SECRET_PATH: '$HOME/.wallpaper.json',
    STORAGE_PATH: '$HOME/mnt/wallpaper',
  }) + { notify: [serviceHandler.name] },
  a.cron(
    name='wallpaper',
    minute='0',
    hour='*',
    command='$HOME/src/wallpaper/sync &> /dev/null'
  ),
  a.serviceDefinition(
    name='wallpaper',
    command='%h/bin/wallpaper',
    envFile='%h/envs/wallpaper.env',
  ) + { notify: [serviceHandler.name] },
  a.service(name='wallpaper'),
];

{
  hostname:: 'wallpaper.local',
  port:: port,
  asPlaybook():: [
    {
      name: 'wallpaper',
      hosts: 'dev.local',
      remote_user: 'alex',
      vars_files: 'secrets.yml',
      tasks: tasks,
      handlers: [serviceHandler],
    },
  ],
}
