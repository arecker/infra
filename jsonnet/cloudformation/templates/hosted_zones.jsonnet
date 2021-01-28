local template_name = 'hosted_zones.yml';

local domains = [
  'alexandmarissa.com.',
  'astuaryart.com.',
  'alexrecker.com.',
  'bobrosssearch.com.',
  'reckerfamily.com.',
  'tranquilitydesignsmn.com.',
];

local toSlug(s) = std.join('', std.split(s, '.'));

local resources = {
  [toSlug(d)]: {
    Type: 'AWS::Route53::HostedZone',
    DeletionPolicy: 'Retain',
    Properties: {
      Name: d,
    },
  }
  for d in domains
};

{
  template_name:: template_name,
  resources:: resources,
  ['cloudformation/templates/' + template_name]: std.manifestYamlStream([{
    Resources: resources,
  }]),
}
