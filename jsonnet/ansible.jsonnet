{
  'hosts': std.manifestYamlDoc(import 'ansible/hosts.jsonnet'),
  'chores.yml': std.manifestYamlDoc(import 'ansible/chores.jsonnet'),
  'jenkins.yml': std.manifestYamlDoc(import 'ansible/jenkins.jsonnet'),
  'minecraft.yml': std.manifestYamlDoc(import 'ansible/minecraft.jsonnet'),
  'patching.yml': std.manifestYamlDoc(import 'ansible/patching.jsonnet'),
  'ssh.yml': std.manifestYamlDoc(import 'ansible/ssh.jsonnet'),
  'wallpaper.yml': std.manifestYamlDoc(import 'ansible/wallpaper.jsonnet'),
}
