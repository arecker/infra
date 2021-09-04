local AuthorizedKeys(user, keys=[]) = {
  name: 'authorized keys: ' + std.join(', ', keys),
  authorized_key: {
    user: user,
    state: 'present',
    key: '{{ lookup("file", "../keys/" + item + ".pub") }}',
  },
  with_items: keys,
};

AuthorizedKeys
