local Config(stacks=[]) = (
  local regions = std.set([s.region for s in stacks]);

  {
    stacks: {
      [r]: {
        [s.name]: {
          template: s.template,
          parameters: s.parameters,
        }
        for s in stacks
        if s.region == r
      }
      for r in regions
    },
  }
);

local Stack(name='', region='', template='', parameters={}) = (
  assert name != '' : '"name" required!';
  assert region != '' : '"region" required!';
  assert template != '' : '"template" required!';

  {
    name:: name,
    region:: region,
    template:: template,
    parameters:: parameters,
  }
);

local Template(filename='', resources=[], parameters=[]) = (
  assert filename != '' : '"filename" required!';

  {
    filename:: filename,
    Parameters: {
      [p.id]: std.prune({
        Type: p.type,
        Default: p.default,
      })
      for p in parameters
    },
    Resources: {
      [r.id]: {
        Type: r.type,
        Properties: r.properties,
      }
      for r in resources
    },
  }
);

local Parameter(id='', type='String', default=null) = (
  assert id != '' : '"id" required!';

  {
    id:: id,
    type:: type,
    default:: default,
  }
);

local Bucket(id='Bucket', name=null) = (
  assert id != '' : '"id" required!';

  {
    id:: id,
    type:: 'AWS::S3::Bucket',
    properties:: std.prune({
      BucketName: name,
    }),
  }
);

local User(id='User') = (
  {
    id:: id,
    type:: 'AWS::IAM::User',
    properties:: {},
  }
);

local UserPolicy(userName='', policyName='', policyStatements=[], id='UserPolicy') = (
  assert userName != '' : '"userName" required!';
  assert policyName != '' : '"policyName" required!';
  {
    id:: id,
    type:: 'AWS::IAM::UserPolicy',
    properties:: {
      UserName: userName,
      PolicyName: policyName,
      PolicyDocument: {
        Version: '2012-10-17',
        Statement: policyStatements,
      },
    },
  }
);

local UserAccessKey(userName='', id='UserAccessKey') = (
  assert userName != '' : '"userName" required!';

  {
    id:: id,
    type:: 'AWS::IAM::AccessKey',
    properties:: {
      UserName: userName,
    },
  }
);

{
  Bucket:: Bucket,
  Config:: Config,
  Parameter:: Parameter,
  Stack:: Stack,
  Template:: Template,
  User:: User,
  UserPolicy:: UserPolicy,
  UserAccessKey:: UserAccessKey,
} + {
  // functions
  join(args=[]):: { 'Fn::Join': ['', args] },
  stackName():: { Ref: 'AWS::StackName' },
  ref(val):: { Ref: val },
}
