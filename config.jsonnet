local compose(cmd) = (
  'docker-compose -f $TRAVIS_BUILD_DIR/docker/docker-compose.yml %s' % cmd
);

local docker = {
  login():: (
    'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
  ),
};

local dockerCompose = {
  version: '3',
  services: {
    [image]: {
      image: 'arecker/%s:latest' % image,
      build: { context: image },
    }
    for image in [
      'chorebot',
      'vault',
    ]
  },
};

local travis = {
  language: 'bash',
  arch: ['arm64'],
  services: ['docker'],
  branches: { only: ['master'] },
  notifications: { email: false },
  jobs: {
    include: [
      {
        stage: 'docker login',
        script: docker.login(),
      },
      {
        stage: 'docker build',
        script: compose('build --parallel'),
      },
    ],
  },
};

{
  '.travis.yml': std.manifestYamlDoc(travis),
  'docker/docker-compose.yml': std.manifestYamlDoc(dockerCompose),
}
