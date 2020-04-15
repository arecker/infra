local tag = 'latest';

{
  images:: [
    'chorebot',
    'hub-proxy',
    'hub-web',
    'vault',
  ],
  projects:: {
    [image]: {
      image: 'arecker/%s:%s' % [image, tag],
      build: {
        context: image,
        dockerfile: 'Dockerfile',
      },
    }
    for image in self.images
  } + {
    'hub-proxy'+: {
      build+: {
	context: 'hub',
        dockerfile: 'dockerfiles/Dockerfile.proxy',
      },
    },
    'hub-web'+: {
      build+: {
	context: 'hub',
        dockerfile: 'dockerfiles/Dockerfile.web',
      },
    },
  },
  'docker/docker-compose.yml': (
    local projects = self.projects;

    std.manifestYamlDoc({
      version: '3',
      services: projects,
    })
  ),
}
