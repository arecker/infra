{
  package(name='', update=false):: {
    name: 'package: ' + name,
    become: true,
    package: {
      name: name,
      state: 'present',
      update_cache: update,
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
  template(name='', dest='', variables={}, become=false, mode='0700'):: {
    name: 'template: ' + dest,
    vars: {
      variables: variables,
    },
    become: become,
    template: {
      src: name,
      dest: dest,
      mode: mode,
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
  cronSpecial(name='', command='', specialTime=''):: {
    name: 'cron: ' + name,
    cron: {
      name: name,
      special_time: specialTime,
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
  copy(src='', dest=''):: {
    name: 'copy: ' + dest,
    copy: {
      src: src,
      dest: dest,
      mode: '640',
    },
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
        description: name + ' service',
        command: command,
        envFile: envFile,
      }
    )
  ),
  service(name='', scope='user'):: {
    name: 'sevice: ' + name,
    become: scope == 'system',
    systemd: {
      name: name,
      daemon_reload: true,
      scope: scope,
      enabled: true,
      state: 'started',
    },
  },
  serviceHandler(name='', scope='user', state='restarted'):: {
    name: 'restart ' + name + ' service',
    become: scope == 'system',
    systemd: {
      name: name,
      state: state,
      scope: scope,
      enabled: true,
      daemon_reload: true,
    },
  },
  aptKey(url=null, keyserver=null, id=null):: {
    name: 'apt-key: ' + (if url != null then url else id),
    become: true,
    apt_key: std.prune({
      url: url,
      id: id,
      keyserver: keyserver,
      state: 'present',
    }),
  },
  getUrl(url='', path=''):: {
    name: 'get_url: ' + path,
    get_url: {
      url: url,
      dest: path,
    },
  },
}
