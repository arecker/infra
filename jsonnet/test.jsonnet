local k = import 'kubernetes.jsonnet';
local api = {};

local testCase = {
  run():: (
    local me = self;
    local objects = std.objectFieldsAll(me);
    local functions = std.filter(function(o) std.type(me[o]) == 'function', objects);
    local testFunctions = std.filter(function(f) std.startsWith(f, 'test'), functions);
    {
      [std.toString(func)]: me[func]()
      for func in testFunctions
    }
  ),
  assertEqual(actual, expected):: (
    std.assertEqual(actual, expected)
  ),
};

local kubernetesTest = testCase {
  testIngress(): (
    local rule = [k.ingressRule('hub', 'hub-proxy', 80)];
    local actual = k.ingress('test').withRules([rule]);
    self.assertEqual(actual.spec.rules, [rule])
  ),
};

{
  '.tests.txt': std.manifestJson({
    kubernetesTest: kubernetesTest.run()
  })
}

