{
  package(name=''):: {
    name: 'package: ' + name,
    become: true,
    package: {
      name: name,
      state: 'present',
    },
  },
  packages(names=[]):: self.package(name='{{ item }}') {
    with_items: names,
  },
  directory(path=''):: {
    name: 'directory: ' + path,
    file: {
      path: path,
      state: 'directory',
      mode: '0751',
    },
  },
  directories(paths=[]):: self.directory(path='{{ item }}') {
    with_items: paths,
  },
  git(url='', dest='', version='master'):: {
    name: 'git: ' + dest,
    git: {
      repo: url,
      dest: dest,
      version: version,
    },
  },
  gitPersonal(repo='', dest='', version='master'):: (
    local url = 'https://www.github.com/arecker/' + repo + '.git';
    self.git(url=url, dest=dest, version=version)
  ),
  venv(name, requirements=''):: {
    name: 'venv: ' + name,
    pip: {
      requirements: requirements,
      virtualenv: '~/venvs/' + name,
      virtualenv_command: 'pyvenv',
    },
  },
  template(name='', dest='', variables={}):: {
    name: 'template: ' + dest,
    vars: {
      variables: variables,
    },
    template: {
      src: name,
      dest: dest,
      mode: '0700',
    },
  },
  cron(name='', command='', minute='*', hour='*'):: {
    name: 'cron: ' + name,
    cron: {
      name: name,
      minute: minute,
      hour: hour,
      job: command,
    },
  },
  bin(name=''):: {
    name: 'bin: ' + name,
    copy: {
      src: 'bin/' + name,
      dest: '~/bin/' + name,
      mode: '0755',
    },
  },
  bins(names=[]):: self.bin(name='{{ item }}') {
    with_items: names,
  },
  mount(url='', path=''):: {
    name: 'mount: ' + path,
    become: true,
    mount: {
      path: path,
      src: url,
      fstype: 'nfs',
      state: 'present',
    },
  },
  serviceDefinition(name='', command='', envFile=''):: (
    self.template(
      name='service.j2',
      dest='~/.config/systemd/user/' + name + '.service',
      variables={
        description: 'service definition: ' + name,
        command: command,
        envFile: envFile,
      }
    )
  ),
}
