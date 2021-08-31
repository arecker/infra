{
  setTimezone():: {
    become: true,
    name: 'set timezone',
    timezone: {
      name: 'America/Chicago',
    },
  },
}
