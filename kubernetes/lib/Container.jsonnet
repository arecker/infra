local new(name='', image='', env={}, volumes={}, roVolumes={}) = (
  {
    name: name,
    image: image,
    imagePullPolicy: 'Always',
    env: [
      {
	name: k,
	value: env[k]
      } for k in std.objectFields(env)],
    volumeMounts: [
      {
	name: k,
	mountPath: volumes[k]
      } for k in std.objectFields(volumes)
    ] + [
      {
	name: k,
	mountPath: roVolumes[k],
	readOnly: true
      } for k in std.objectFields(roVolumes)
    ]
  }
);

{ new: new }
