VAULT_ID=--vault-id infra@scripts/pass-vault-client.py
ANSIBLE=ansible-playbook -K -i ansible/hosts.yml $(VAULT_ID)
JSONNET=jsonnet -S -m .

.PHONY: all
all: build

.PHONY: build
build: jsonnet ansible-lint

.PHONY: jsonnet
jsonnet:
	$(JSONNET) jsonnet/all.jsonnet

.PHONY: ansible-lint
ansible-lint:
	ansible-lint ansible/dev.yml

.PHONY: secrets
secrets:
	EDITOR="emacsclient" ansible-vault edit $(VAULT_ID) ansible/secrets.yml

.PHONY: dev
dev: build
	$(ANSIBLE) ansible/dev.yml

.PHONY: chores
chores: build
	$(ANSIBLE) ansible/chores.yml
