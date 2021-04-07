local a = import 'lib/ansible.libsonnet';


local tasks = [
  a.packages(names=[
    'imagemagick',
    'libapache2-mod-php',
    'php',
    'php-curl',
    'php-mbstring',
    'php-mysql',
    'php-xml',
  ]),
  a.template(
    name='php.ini.j2',
    dest='/etc/php/7.3/apache2/php.ini',
    become=true,
    mode='0644'
  ),
];

{
  'ansible/php.yml': std.manifestYamlStream([self.asPlaybook()]),
  asPlaybook():: [
    {
      name: 'php',
      hosts: 'prod',
      vars_files: 'secrets/secrets.yml',
      tasks: tasks,
      handlers: [],
    },
  ],
}
