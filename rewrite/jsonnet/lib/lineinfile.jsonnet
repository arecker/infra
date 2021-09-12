local LineInFile(line='', file='', become=false) = {
  name: 'line in file: ' + file,
  become: become,
  lineinfile: {
    path: file,
    line: line,
  },
};

LineInFile
