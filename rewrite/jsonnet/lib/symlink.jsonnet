local Symlink(src='', dest='') = {
  name: 'symlink ' + src + ' -> ' + dest,
  file: {
    src: src,
    dest: dest,
    state: 'link',
    force: true,
  },
};

Symlink
