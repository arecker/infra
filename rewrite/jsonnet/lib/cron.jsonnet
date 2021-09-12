local Cron(name='', command='', specialTime=null) = {
  name: 'cron: ' + name,
  cron: {
    name: name,
    special_time: specialTime,
    job: command,
  },
};

Cron
