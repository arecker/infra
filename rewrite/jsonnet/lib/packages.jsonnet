local Package = import 'package.jsonnet';

local Packages(names=[], update=false) = Package(name='{{ item }}') {
  with_items: names,
};

Packages
