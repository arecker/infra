local lib = import './_lib.jsonnet';

local config = lib.Config(
  stacks=[
    lib.Stack(
      region='us-east-2',
      name='astuary-backup',
      template=(import './templates/bucket.jsonnet').filename,
      parameters={
        BucketName: 'astuary-art-backup',
      }
    ),
  ]
);

{
  'stack_master.yml': std.manifestYamlStream([config]),
}
