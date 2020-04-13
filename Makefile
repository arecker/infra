.PHONY: all jsonnet test

all: test jsonnet

test:
	jsonnet jsonnet/test.jsonnet

jsonnet:
	jsonnetfmt -i jsonnet/ingress.jsonnet
	jsonnet -m . -S jsonnet/ingress.jsonnet
