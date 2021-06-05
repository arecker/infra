JSONNET_FILES = $(wildcard jsonnet/*.jsonnet)
JSONNET_TARGETS = $(patsubst jsonnet/%.jsonnet, %, $(JSONNET_FILES))

# @echo JSONNET_FILES: $(JSONNET_FILES)

.PHONY: all clean $(JSONNET_TARGETS)
all: $(JSONNET_TARGETS)

$(JSONNET_TARGETS):
	jsonnet -m $@ -S jsonnet/$@.jsonnet

clean:
	rm ansible/*.yml
	rm ansible/hosts
