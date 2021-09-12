local Template = import 'template.jsonnet';


local AuthorizedKeys(keys=[]) = (
  Template(name='authorized_keys.j2', dest='~/.ssh/authorized_keys', variables={ public_keys: keys })
);

AuthorizedKeys
