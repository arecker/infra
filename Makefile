.PHONY: all jsonnet

all: jsonnet

jsonnet:
	jsonnetfmt -i config.jsonnet
	jsonnet -m . -S config.jsonnet
