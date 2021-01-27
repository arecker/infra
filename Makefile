VAULT_ID=--vault-id infra@scripts/pass-vault-client.py

JSONNET_FILES = $(wildcard jsonnet/*.jsonnet)
ANSIBLE_FILES = $(addprefix ansible/, $(notdir $(patsubst %.jsonnet, %.yml, $(JSONNET_FILES))))

.PHONY: all
all: $(ANSIBLE_FILES)

ansible/%.yml: jsonnet/%.jsonnet
	jsonnet -S -m . $<
	ansible-lint $@
	touch $@

PLAYBOOKS = dev jenkins chores wallpaper
.PHONY: install $(PLAYBOOKS)
install: $(PLAYBOOKS)
$(PLAYBOOKS): $(ANSIBLE_FILES)
	ansible-playbook -i ansible/hosts.yml $(VAULT_ID) ansible/$@.yml

.PHONY: secrets
secrets:
	EDITOR="emacsclient" ansible-vault edit $(VAULT_ID) ansible/secrets/secrets.yml
