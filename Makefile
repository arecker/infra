.phony: all
all: compile ansible

.phony: compile
compile:
	@for source in $(wildcard jsonnet/*.jsonnet); do \
		echo "==> compiling $$source" ;\
		jsonnet -m . -S "$$source" ;\
	done

.phony: clean
clean:
	@echo "==> cleaning jsonnet artifacts"
	rm -f ./playbooks.yml
	rm -f ./hosts.yml
	@echo "==> cleaning python venv"
	rm -rf ./venv

venv/bin/ansible-playbook:
	@echo "==> building python venv"
	python -m venv ./venv
	@echo "==> upgrading pip"
	./venv/bin/pip install -q --upgrade pip
	@echo "==> installing ansible"
	./venv/bin/pip install -q --upgrade ansible

.phony: ansible
ansible: compile venv/bin/ansible-playbook
	@echo "==> running ansible project"
	ansible-playbook -i hosts.yml --vault-id infra@scripts/pass-vault-client.py playbooks.yml
