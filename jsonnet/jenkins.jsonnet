local a = import 'lib/ansible.libsonnet';

local serviceHandler = a.serviceHandler(name='nginx', scope='system', state='reloaded');

local tasks = [
  a.packages([
    'bats',
    'curl',
    'default-jdk',
    'dnsutils',
    'git',
    'gnupg2',
    'nginx',
    'python3',
    'python3-pip',
    'wget',
  ]),

  // Install Jenkins
  a.aptKey(url='https://pkg.jenkins.io/debian/jenkins.io.key'),
  a.template(name='jenkins.list.j2', dest='/etc/apt/sources.list.d/jenkins.list', become=true, mode='0744'),
  a.template(name='jenkins.env.j2', dest='/etc/default/jenkins', become=true, mode='0644'),
  a.package(name='jenkins', update=true),
  a.service(name='jenkins', scope='system'),

  // Setup SSH
  a.directory(path='/var/lib/jenkins/.ssh', owner='jenkins', group='jenkins', mode='700'),
  a.template(
    name='file.j2',
    dest='/var/lib/jenkins/.ssh/id_rsa',
    mode='700',
    owner='jenkins',
    group='jenkins',
    become=true,
    variables={
      content: '{{ secrets.jenkins.private }}',
    }
  ),

  // Setup Proxy
  a.template(
    name='nginx/jenkins.conf.j2',
    dest='/etc/nginx/nginx.conf',
    become=true,
  ) + { notify: [serviceHandler.name] },
  a.service(name='nginx', scope='system'),

  // Setup some tools
  a.pip('ansible'),
  {
    name: 'untar jsonnet',
    become: true,
    unarchive: {
      src: 'https://github.com/google/jsonnet/releases/download/v0.17.0/jsonnet-bin-v0.17.0-linux.tar.gz',
      dest: '/usr/local/bin',
      remote_src: true,
    },
  },

  // Hack for fixing python path
  {
    name: 'fix python with symlink',
    become: true,
    file: {
      src: '/usr/bin/python3',
      dest: '/usr/bin/python',
      state: 'link',
    },
  },
];

{
  'ansible/jenkins.yml': std.manifestYamlStream([self.asPlaybook()]),
  asPlaybook():: [
    {
      name: 'jenkins server',
      hosts: 'jenkins.local',
      vars_files: 'secrets/secrets.yml',
      tasks: tasks,
      handlers: [serviceHandler],
    },
  ],
}
