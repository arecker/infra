local GetUrl(url='', dest='', mode='0400') = {
  name: 'get url ' + url,
  get_url: {
    url: url,
    dest: dest,
    mode: mode,
  },
};

GetUrl
