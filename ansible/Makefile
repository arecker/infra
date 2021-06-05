ANSIBLE_TARGETS := $(patsubst %.yml,%, $(wildcard *.yml))

VAULT_ID := --vault-id infra@scripts/pass-vault-client.py

.PHONY: all
all:
	@echo no default target

.PHONY: secrets
secrets:
	cd .. && EDITOR="emacsclient" ansible-vault edit $(VAULT_ID) ansible/secrets/secrets.yml

.PHONY: $(ANSIBLE_TARGETS)
$(ANSIBLE_TARGETS):
	cd .. && ansible-playbook -i ansible/hosts $(VAULT_ID) ansible/$@.yml
