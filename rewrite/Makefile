PLAYBOOKS = console
PLAYBOOK_TARGETS = $(patsubst %, playbooks/%.yml, $(PLAYBOOKS))
JSONNET_TARGETS = $(PLAYBOOK_TARGETS) inventory/hosts.yml
JSONNET_LIBS = $(wildcard jsonnet/lib/*.jsonnet)

VAULT_ID = infra@scripts/pass-vault-client.py

.PHONY: all
all: $(JSONNET_TARGETS)

playbooks/%.yml inventory/%.yml: jsonnet/%.jsonnet jsonnet/hosts.jsonnet $(JSONNET_LIBS)
	jsonnet -S -e '(import "$<").export()' > $@ && touch $@

.PHONY: $(PLAYBOOKS)
$(PLAYBOOKS): $(JSONNET_TARGETS)
	ansible-playbook -i inventory/hosts.yml --vault-id "$(VAULT_ID)" "playbooks/$@.yml"

.PHONY: clean
clean:
	rm -rf $(JSONNET_TARGETS)
