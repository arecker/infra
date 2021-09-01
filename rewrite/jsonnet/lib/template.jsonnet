local Template(name='', dest='', variables={}, become=false, mode='0700', owner=null, group=null) = {
  name: 'render template: ' + name,
  vars: {
    variables: variables,
  },
  become: become,
  template: std.prune({
    src: '../templates/' + name,
    dest: dest,
    mode: mode,
    owner: owner,
    group: group,
  }),
};

Template
