PROJECTS := aws tranquility wedding
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
