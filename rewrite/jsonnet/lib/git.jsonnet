local Git(url='', dest='', version='master', become=false) = std.prune({
  name: 'git: ' + dest,
  become: become,
  git: {
    repo: url,
    dest: dest,
    version: version,
  },
});

Git
