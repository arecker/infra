local docker = (
  local projects = [
    'chorebot',
    'vault',
  ];
  {
    projects: projects,
    login():: (
      'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
    ),
    compose(cmd):: (
      'docker-compose -f $TRAVIS_BUILD_DIR/docker/docker-compose.yml %s' % cmd
    ),
    asComposeFile():: (
      {
        version: '3',
        services: {
          [project]: {
            image: 'arecker/%s:latest' % project,
            build: { context: project },
          }
          for project in projects
        },
      }
    ),
  }
);

local travis = {
  asTravisFile():: {
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
  },
};

{
  '.travis.yml': std.manifestYamlDoc(travis.asTravisFile()),
  'docker/docker-compose.yml': std.manifestYamlDoc(docker.asComposeFile()),
}
