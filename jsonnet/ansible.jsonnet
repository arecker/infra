{
  'hosts.yml': std.manifestYamlDoc(import 'ansible/hosts.jsonnet'),
  'playbooks.yml': std.manifestYamlStream([
    import 'ansible/base.jsonnet',
  ]),
}
