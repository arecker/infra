TERRAFORM := aws-personal.sh terraform
PROJECTS := $(shell find ./ -maxdepth 1 -type d -not -path ./ -not -path ./modules)

.PHONY: all
all: secrets

do/token:
	pass digitalocean/terraform | tr -d '\n' > $@

secrets: do/token

.PHONY: $(PROJECTS)

$(PROJECTS): secrets
	@echo "running project: $@"
	cd $@ && $(TERRAFORM) init && $(TERRAFORM) apply
