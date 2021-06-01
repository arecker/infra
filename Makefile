ANSIBLE_PLAYBOOKS := chores jenkins minecraft patching wallpaper
ANSIBLE_TARGETS := $(patsubst %, ansible/%.yml, $(ANSIBLE_PLAYBOOKS)) ansible/hosts.yml

VAULT_ID := --vault-id infra@scripts/pass-vault-client.py

JSONNET_FILES = $(wildcard jsonnet/*.jsonnet)
LIBSONNET_FILES = $(wildcard jsonnet/lib/*.libsonnet)

.PHONY: all
all: $(ANSIBLE_TARGETS)

ansible/%.yml: jsonnet/%.jsonnet $(JSONNET_FILES) $(LIBSONNET_FILES)
	jsonnet -S -m . $< && touch $@

.PHONY: $(ANSIBLE_PLAYBOOKS)
$(ANSIBLE_PLAYBOOKS): $(ANSIBLE_TARGETS)
	ansible-playbook -i ansible/hosts.yml $(VAULT_ID) ansible/$@.yml

.PHONY: secrets
secrets:
	EDITOR="emacsclient" ansible-vault edit $(VAULT_ID) ansible/secrets/secrets.yml

.PHONY: clean
clean:
	rm -rf $(ANSIBLE_TARGETS)
