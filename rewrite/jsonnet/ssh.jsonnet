local Hosts = import 'hosts.jsonnet';
local AuthorizedKeys = import 'lib/authorized_keys.jsonnet';
local Package = import 'lib/package.jsonnet';
local Playbook = import 'lib/playbook.jsonnet';
local Template = import 'lib/template.jsonnet';

local personalPubKey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQC9QRF+oAR4kRPvkVWN1/J/JsgO3rGYY9Qi2RvjXZ7BYx6BO+gDFJ+KlMtI79UuY1Kz3g1lym9glKBnXd2VNNHIZosc5F9jbatH8KnYeNwJa7Rr8xzBbRPONFJ7rS9jLVBXfTFABAabspb6XHopN6ky1jpSNtPY6xu9xIXRL7LRLHDQJSWM2aY/7xF+SXCik6jn3iuMjO/zmmveWbpZCnDRyoDYRiwVyJ/Q9Y3bNhIWyNpwSS7Ica3uIz18172s/PVUsHrk6+mhp0Ucvo/R+2Wq8eJKc01zldHlaADn2DVnKaE0QX0MzNp4MC9fMp52B84MOeaYAIRvbBJH9KjnF0vPEBPt5rn4U0nKRvKv6/gvnFMTMBnUhROoF0wwj0DQ7YXcSd0n6eFXpQIt/gv6B1s1mX4tSnshICm/FpZqqNtJvxTE0TiGkSzURnoiMpLmUxb3kBVXej0tojgRPiptRBQUq1vUNCvS3mxaVb9zenmQs4dQTTus+gl+faZbE0khDfZdKLy9y+M8pb+CH0lB935RMPynXTyAOWSupcFumb/j4GSbRJ0KzWqiwAESgTmhbZqNg40D+6N46bcFxxDzQ9A3dnAw1ddrNxzrdjD6pmZtt+rb6A20Ue+WiKSzafuoiEnE6cRVU+F3jpVPHglEAz/qaHVgWWV9GTI3XxNqSN5/Y7eAatyzfPbmJMSAtOg8/g5ptAQPdu2wvaLmVa7sZMyF06OWVZgqXuXjde5sHdryMhfVc6PBqL8Nc94N7jChzLFigT+pR1e6uxQ2mEWXPRHoZYrrxkWHCqAU0L+XZGKDVQJn66MHOtpgJ2dzs5DH2SukPRLuO2B4Odqym9TmYmnV9Uxndwsu3iVedDZSZbMF+JXgDucScGQlNRUE2UXHkqhfyYB7BEzJFkhiHeLb1kwwzp630YsDoS3omQWevqy3kUM7j7626Uhy5uYlNA7EcmrHWnGymOReBJ/wbMMOL0rDwWBNf+FH5brHJ41JwMS8d+u4l8knmQ/tbmU1iYnYjaX4Gl//qiM24krNKyzVaVQzV6c/XSlljmkmOLq4zsMWLEdmv8XGZHpWRCw0vAZfShWJwHY/hFtnrUC3s687HqOsv5UcZtYHyIEx8dBSr6xemneFCLZhGoC2a/qTF7D414WQOtJI/WcDU+PweKgMU7iMV+DsRaVvP+BqhbFloZLTUyHz6j9e51+snQHxVnS0Q3hY0be5pUGtMuf7sUeLl49sZ8BpFX+JnN+dES9iQWtMH6VSASmhcBtwLxNoJm0ilgt46uBm4XbbTjcBbt781Xwa4e+0c56bZQRLGudCtoThJ6okdrIL3PTMZaE3v190louzM7F2kmJpEK/RXVAkyqkJ alex@reckerfamily.com';

local jenkinsPubKey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDO2i9WTVnpKkTJiQe9LlX/RYsau3b/E9NmE5B5M9CHBKK+u83UiL1Yu8ZAQRdEfnWke7qaiD/B9YBRZV6DnmiVXvgZxYbdb7N+tnIKE9g9jj+5QIcYmIL3mhFXC5An2tc97sjqetsmjq+E4baRfygHNAP4TeNzuRhfoBAfVXBenpyCV0XDR8R0ph+qVhYY1HDYKhC78Ufvj4i2yLkIu4SLPUkDX/lA1Wff1aflWIzqC9uCvFndZ3gFImDvTo0n/tup0Xjn/WRNFjyF41V42NjI0D2jhp6JVEN/YlESP42Izmu43SHxZvcE0cLj1TM/DpbCbYw/VHoYLsDIdRM0H9LlyT/9H2uDNoFuEiQsPZ20ykkeemiLuPBGOOGvhUjxxTGprBBcskKaytGcDHhYQUtgejDjfKIEmH9nVdtNug+NlATn7w2PfTjfobtGd3JHAEJ5r9z7C8aXh6nxABcLijeHPmbZvPtydR8PBDQyWIbcTd/rRM+3m6M+/r/UtdZ+TjgEZ14e/Wipbba60M8TQrW8XeKbNEe9KxibLmUaNAlULhS6TFNESlkkcAsqVITqi/rq6FkjJoxIvMiDn0G6C4FGbAOVgX2PnH0Q5nbQ0Z/9VqCYsb5ipRW0X8iEIj6kohB9wlOC9BpZHpqN5kyiBPpIEKJqIjEyoYrBy4zn+NXqCw== jenkins@jenkins.local';

local tasks = [
  Package(name='openssh-server'),
  Template(name='sshd.conf.j2', dest='/etc/ssh/sshd_config', become=true, mode='644', owner='root', group='root'),
  AuthorizedKeys(keys=[personalPubKey, jenkinsPubKey]),
];

Playbook('ssh', hosts=Hosts.ssh(), tasks=tasks)
