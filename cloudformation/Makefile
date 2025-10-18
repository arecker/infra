.PHONY: all
all: jsonnet

.PHONY: jsonnet
jsonnet: config templates

.PHONY: config
config:
	jsonnet -m . -S jsonnet/config.jsonnet

.PHONY: templates
templates:
	jsonnet -m ./templates -S jsonnet/templates.jsonnet

.PHONY: install
install:
	bundle install --quiet

.PHONY: apply
apply: install jsonnet
	bundle exec stack_master apply --yes

.PHONY: validate
validate: install jsonnet
	bundle exec stack_master validate
