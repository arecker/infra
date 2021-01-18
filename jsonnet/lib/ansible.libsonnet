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
}
