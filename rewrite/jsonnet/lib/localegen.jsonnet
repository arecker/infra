local LocaleGen(name='en_US.UTF-8') = {
  name: 'locale: ' + name,
  become: true,
  locale_gen: {
    name: name,
    state: 'present',
  },
};

LocaleGen
