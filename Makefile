VAULT_ID=--vault-id infra@scripts/pass-vault-client.py
ANSIBLE=ansible-playbook -i ansible/hosts.yml $(VAULT_ID)
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
	ansible-lint ansible/chores.yml

.PHONY: secrets
secrets:
	EDITOR="emacsclient" ansible-vault edit $(VAULT_ID) ansible/secrets.yml

.PHONY: dev
dev: build
	$(ANSIBLE) -K ansible/dev.yml

.PHONY: chores
chores: build
	$(ANSIBLE) ansible/chores.yml
