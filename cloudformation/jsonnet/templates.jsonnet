local templates = [
  import './templates/bucket.jsonnet',
];

{
  [t.filename]: std.manifestYamlStream([t])
  for t in templates
}
