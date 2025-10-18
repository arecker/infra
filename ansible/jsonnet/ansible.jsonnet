local HostsFile = {
  vars: {
    ansible_user: 'jenkins',
  },
  hosts: {
    'jenkins.local': {},
    'webserver.local': {},
    'database.local': {},
  },
};

{
  'hosts.yml': std.manifestYamlStream([HostsFile]),
}
