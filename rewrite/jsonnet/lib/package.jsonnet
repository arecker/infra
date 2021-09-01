local Package(name='', update=false) = {
  name: 'install package: ' + name,
  become: true,
  package: {
    name: name,
    state: 'present',
    update_cache: update,
  },
};

Package
