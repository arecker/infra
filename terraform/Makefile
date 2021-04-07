PROJECTS := $(shell find ./ -maxdepth 1 -type d -not -path ./ -not -path ./modules -not -path ./secrets)
SECRETS := cloudflare digitalocean
TERRAFORM := aws-personal.sh terraform

.PHONY: all
all: secrets

.PHONY: secrets
secrets: $(addprefix secrets/, $(SECRETS))
$(addprefix secrets/, $(SECRETS)):
	pass $(patsubst secrets/%,infra/%,$@) | tr -d '\n' > $@


.PHONY: $(PROJECTS)
$(PROJECTS): secrets
	@echo "running project: $@"
	cd $@ && $(TERRAFORM) init && $(TERRAFORM) apply
