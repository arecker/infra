FROM vault:latest
MAINTAINER Alex Recker <alex@reckerfamily.com>
ADD vault.hcl /vault/config/vault.hcl
RUN chown vault:vault /vault/config/vault.hcl
USER "vault"
WORKDIR "/vault"
ENV PS1 "\u@vault:\w\$ "
CMD ["/usr/bin/env", "sh"]
