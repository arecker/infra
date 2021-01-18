ANSIBLE=ansible-playbook -K -i ansible/hosts.yml --vault-id infra@scripts/pass-vault-client.py
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
	ansible-lint ansible/playbooks/*.yml

.PHONY: dev
dev: build
	$(ANSIBLE) ansible/playbooks/dev.yml
