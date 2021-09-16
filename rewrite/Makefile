BIN_TARGETS = bin/packer bin/jsonnet

PLAYBOOK_SOURCES = $(shell find jsonnet ! -path 'jsonnet/lib/*' ! -name 'hosts.jsonnet' -path '*.jsonnet')
PLAYBOOKS = $(basename $(notdir $(PLAYBOOK_SOURCES)))
PLAYBOOK_TARGETS = $(patsubst %, playbooks/%.yml, $(PLAYBOOKS))

JSONNET_TARGETS = packer/packer.json inventory/hosts.yml $(PLAYBOOK_TARGETS)
JSONNET_LIBS = $(wildcard jsonnet/lib/*.jsonnet)
JSONNET_DEPS = jsonnet/hosts.jsonnet jsonnet/python.jsonnet bin/jsonnet

PACKER_VERSION = 1.7.5

VAULT_ID = infra@scripts/pass-vault-client.py

.PHONY: all
all: $(BIN_TARGETS) $(JSONNET_TARGETS)

bin/packer:
	@echo "==> downloading packer"
	wget -q -O tmp/packer.zip "https://releases.hashicorp.com/packer/$(PACKER_VERSION)/packer_$(PACKER_VERSION)_linux_amd64.zip"
	unzip tmp/packer.zip -d bin/
	chmod +x bin/packer
	rm -rf bin/README.md bin/LICENSCE

bin/jsonnet:
	@echo "==> downloading jsonnet"
	wget -q -O tmp/jsonnet.tar.gz "https://github.com/google/go-jsonnet/releases/download/v0.17.0/go-jsonnet_0.17.0_Linux_x86_64.tar.gz"
	tar xvf tmp/jsonnet.tar.gz -C bin/
	chmod +x bin/jsonnet
	rm -rf bin/README.md bin/LICENSCE

packer/%.json playbooks/%.yml inventory/%.yml: jsonnet/%.jsonnet $(JSONNET_DEPS) $(JSONNET_LIBS)
	@echo "==> building $< -> $@"
	@./bin/jsonnet -S -e '(import "$<").export()' > $@ && touch $@

.PHONY: $(PLAYBOOKS)
$(PLAYBOOKS): $(JSONNET_TARGETS)
	ansible-playbook -i inventory/hosts.yml --vault-id "$(VAULT_ID)" "playbooks/$@.yml"

.PHONY: clean
clean:
	rm -rf $(JSONNET_TARGETS)
	rm -rf $(BIN_TARGETS)
	rm -rf tmp/*
