local hosted_zones = import 'templates/hosted_zones.jsonnet';

{
  'cloudformation/stack_master.yml': std.manifestYamlStream([{
    stacks: {
      'us-east-2': {
        'hosted-zones': {
          template: hosted_zones.template_name,
        },
      },
    },
  }]),
}
