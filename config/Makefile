DHALL_TO_YAML = dhall-to-yaml-ng

playbooks/console.yml: console.dhall
	$(DHALL_TO_YAML) --file "console.dhall" --output "$@" --generated-comment

.PHONY: clean
clean:
	rm -rf playbooks/console.yml
