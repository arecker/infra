local hosts = [
  'dev.local',
];

{
  all: {
    hosts: {
      [host]: {}
      for host in hosts
    },
  },
}
