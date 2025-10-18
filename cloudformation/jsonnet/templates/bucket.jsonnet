local lib = import '../_lib.jsonnet';

local nameParam = lib.Parameter(id='BucketName');
local user = lib.User();
local bucket = lib.Bucket(name=lib.ref(nameParam.id));
local policy = lib.UserPolicy(
  userName=lib.ref(user.id),
  policyName=lib.join([lib.stackName(), '-policy']),
  policyStatements=[
    {
      Effect: 'Allow',
      Action: [
        's3:GetObject',
        's3:PutObject',
        's3:DeleteObject',
        's3:ListBucket',
      ],
      Resource: [
        lib.join(['arn:aws:s3:::', lib.ref(bucket.id)]),
        lib.join(['arn:aws:s3:::', lib.ref(bucket.id), '/*']),
      ],
    },
  ]
);

lib.Template(
  filename='bucket.json',
  parameters=[
    nameParam,
  ],
  resources=[
    bucket,
    user,
    policy,
  ],
)
