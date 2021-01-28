VAULT_ID=--vault-id infra@scripts/pass-vault-client.py

ANSIBLE_JSONNET_FILES = $(wildcard jsonnet/ansible/*.jsonnet)
ANSIBLE_FILES = $(addprefix ansible/, $(notdir $(patsubst %.jsonnet, %.yml, $(ANSIBLE_JSONNET_FILES))))
CLOUDFORMATION_JSONNET_FILES = $(shell find jsonnet/cloudformation -type f -name '*.jsonnet')
CLOUDFORMATION_FILES = $(subst jsonnet/,, $(patsubst %.jsonnet, %.yml, $(CLOUDFORMATION_JSONNET_FILES)))

.PHONY: all
all: $(ANSIBLE_FILES) $(CLOUDFORMATION_FILES)

ansible/%.yml: jsonnet/ansible/%.jsonnet
	jsonnet -S -m . $<
	ansible-lint $@
	touch $@

cloudformation/%.yml: jsonnet/cloudformation/%.jsonnet
	jsonnet -S -m . $<
	touch $@

PLAYBOOKS = dev jenkins chores wallpaper
.PHONY: ansible $(PLAYBOOKS)
ansible: $(PLAYBOOKS)
$(PLAYBOOKS): $(ANSIBLE_FILES)
	ansible-playbook -i ansible/hosts.yml $(VAULT_ID) ansible/$@.yml

.PHONY: secrets
secrets:
	EDITOR="emacsclient" ansible-vault edit $(VAULT_ID) ansible/secrets/secrets.yml

STACKMASTER = cd cloudformation && bundle exec stack_master
.PHONY: stacks
stacks: $(CLOUDFORMATION_FILES)
	$(STACKMASTER) apply --no
