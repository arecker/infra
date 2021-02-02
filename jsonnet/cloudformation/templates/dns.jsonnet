local hosted_zone = import 'hosted_zone.jsonnet';

local api = {

};

local entries = {
  wedding: api.DnsParams(zoneName='alexandmarissa.com.',),
  astuary: api.DnsParams(zoneName='astuaryart.com.',),
  blog: api.DnsParams(zoneName='alexrecker.com.',),
  bob: api.DnsParams(zoneName='bobrosssearch.com.',),
  family: api.DnsParams(zoneName='reckerfamily.com.',),
  tranquility: api.DnsParams(zoneName='tranquilitydesignsmn.com.'),
};

api {

}
