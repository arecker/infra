local PipPackage(name='') = {
  name: 'install pip package: ' + name,
  pip: {
    name: name,
    executable: '~/bin/pip',
  },
};

PipPackage
