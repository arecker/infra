jsonnetFiles = $(wildcard jsonnet/*.jsonnet)
jsonnetFlags = -m . -S

.PHONY: jsonnet test all

jsonnet:
	for file in $(jsonnetFiles); do jsonnet $(jsonnetFlags) $$file; done

test:
	jsonnet $(jsonnetFlags) jsonnet/test.jsonnet

all: test jsonnet
