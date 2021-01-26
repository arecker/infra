local a = import 'lib/ansible.libsonnet';

local tasks = [
  a.bin('sync'),
  a.gitPersonal(repo='wallpaper', dest='~/src/wallpaper'),
  a.venv('wallpaper', requirements='~/src/wallpaper/requirements.txt'),
  a.copy('credentials.json', '~/.wallpaper.json'),
  a.template('env.j2', '~/envs/wallpaper.env', variables={
    GPHOTOS_COMMAND_PATH: '$HOME/venvs/wallpaper/bin/gphotos-sync',
    SECRET_PATH: '$HOME/.wallpaper.json',
    STORAGE_PATH: '$HOME/mnt/wallpaper',
  }),
  a.cron(
    name='wallpaper',
    minute='0',
    hour='*',
    command='$HOME/src/wallpaper/sync &> /dev/null'
  ),
];

{
  asPlaybook():: [
    {
      name: 'wallpaper',
      hosts: 'dev.local',
      remote_user: 'alex',
      vars_files: 'secrets.yml',
      tasks: tasks,
    },
  ],
}
