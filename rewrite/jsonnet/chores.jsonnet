local Hosts = import 'hosts.jsonnet';
local GetUrl = import 'lib/geturl.jsonnet';
local Git = import 'lib/git.jsonnet';
local LauncherEnv = import 'lib/launcherenv.jsonnet';
local PipPackages = import 'lib/pippackages.jsonnet';
local Playbook = import 'lib/playbook.jsonnet';
local Symlink = import 'lib/symlink.jsonnet';
local PythonVersion = (import 'python.jsonnet').PythonVersion;
local Cron = import 'lib/cron.jsonnet';

local installLauncher = GetUrl(url='https://raw.githubusercontent.com/arecker/launcher/main/launcher', dest='~/bin/launcher', mode='0755');

local cloneSource = Git(
  url='https://github.com/arecker/chores.git',
  dest='~/src/chores',
);

local pipPackages = PipPackages(names=[
  'Flask',
  'Flask-SQLAlchemy',
  'SQLAlchemy-Utils',
  'gunicorn',
  'python-dateutil',
  'requests',
  'sqlalchemy',
]);

local launcherEnv = LauncherEnv(
  path='~/src/chores/launcher.env',
  data={
    FLASK_ENV: 'production',
    HUB_URL: 'http://chores.local',
    PORT: '5000',
    PYTHONDONTWRITEBYTECODE: '1',
    PYTHONUNBUFFERED: '1',
    WEBHOOK_URL: '{{ secrets.chores_webhook_url }}',
    WORKERS: '2',
  }
);

local gunicornSymlink = Symlink(
  src='~/.pyenv/versions/' + PythonVersion + '/bin/gunicorn',
  dest='~/bin/gunicorn',
);

local rebootCron = Cron(
  name='chores site',
  command='~/bin/launcher --config ~/src/chores/launcher.config',
  specialTime='reboot'
);

local tasks = [
  cloneSource,
  installLauncher,
  launcherEnv,
  pipPackages,
  gunicornSymlink,
  rebootCron,
];

Playbook('chores', hosts=['chores.local'], tasks=tasks)
