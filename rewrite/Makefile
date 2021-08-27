PLAYBOOKS = console
PLAYBOOK_TARGETS = $(patsubst %, playbooks/%.yml, $(PLAYBOOKS))
JSONNET_TARGETS = $(PLAYBOOK_TARGETS) inventory/hosts.yml

.PHONY: all
all: $(JSONNET_TARGETS)

playbooks/%.yml: jsonnet/%.jsonnet
	jsonnet -S -e '(import "$<").export()' > $@ && touch $@

inventory/hosts.yml: jsonnet/hosts.jsonnet
	jsonnet -S -e '(import "$<").export()' > $@ && touch $@

.PHONY: clean
clean:
	rm -rf $(JSONNET_TARGETS)
