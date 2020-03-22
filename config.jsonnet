local docker = {
  login():: (
    'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
  ),
  compose(cmd):: (
    'docker-compose -f $TRAVIS_BUILD_DIR/docker/docker-compose.yml %s' % cmd
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
        stage: 'docker',
        script: [
          docker.login(),
          docker.compose('build --parallel'),
          docker.compose('push'),
        ],
      },
    ],
  },
};

{
  '.travis.yml': std.manifestYamlDoc(travis),
  'docker/docker-compose.yml': std.manifestYamlDoc(dockerCompose),
}
