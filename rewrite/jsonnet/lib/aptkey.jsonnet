local AptKey(url=null, keyserver=null, id=null) = {
  name: 'apt-key: ' + (if url != null then url else id),
  become: true,
  apt_key: std.prune({
    url: url,
    id: id,
    keyserver: keyserver,
    state: 'present',
  }),
};

AptKey
