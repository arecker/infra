local Template = import 'template.jsonnet';

local LauncherEnv(path='', data={}) = (
  Template(
    name='env.j2',
    dest=path,
    variables=data,
    become=false,
    mode='400'
  )
);

LauncherEnv
