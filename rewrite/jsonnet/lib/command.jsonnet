local Command(command='', creates=null) = {
  name: 'command: ' + command,
  command: std.prune({
    cmd: command,
    creates: creates,
  }),
};

Command
