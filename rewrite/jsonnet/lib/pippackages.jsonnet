local PipPackage = import 'pippackage.jsonnet';

local PipPackages(names=[]) = (
  PipPackage(name=names) {
    name: 'install pip packages: ' + std.join(', ', names),
  }
);

PipPackages
