.PHONY: config
config:
	jsonnet -S -m . ./jsonnet/ansible.jsonnet


.PHONY: install
venv/bin/python:
	rm -rf ./venv
	python -m venv --copies ./venv
	./venv/bin/pip install --quiet --upgrade pip
	./venv/bin/pip install --quiet ansible pytest-testinfra

.PHONY: clean
clean:
	rm -rf ./venv

.PHONY: apply
apply: install config
	./venv/bin/ansible-playbook -i HOSTS --vault-id infra@scripts/pass-vault-client.py config.yml
