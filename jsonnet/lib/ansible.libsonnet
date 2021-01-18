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
      mode: '0600',
    },
  },
}
