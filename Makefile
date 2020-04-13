.PHONY: all jsonnet test

all: test jsonnet

test:
	jsonnet jsonnet/test.jsonnet

jsonnet:
	jsonnetfmt -i jsonnet/hub.jsonnet
	jsonnet -m . -S jsonnet/hub.jsonnet
