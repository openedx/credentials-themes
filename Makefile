.DEFAULT_GOAL := help

.PHONY: help build build.watch compile_translations detect_changed_source_translations dummy_translations \
        extract_translations generate_translations base_requirements pull_translations push_translations \
        requirements test upgrade validate_translations install_transifex_client

NODE_BIN=$(CURDIR)/node_modules/.bin

THEME_NAME := edx_credentials_themes

# Generates a help message. Borrowed from https://github.com/pydanny/cookiecutter-djangopackage.
help: ## display this help message
	@echo "Please use \`make <target>\` where <target> is one of"
	@awk -F ':.*?## ' '/^[a-zA-Z]/ && NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

build:
	$(NODE_BIN)/webpack --config webpack.config.js --progress

build.watch:
	$(NODE_BIN)/webpack --config webpack.config.js --progress --watch

compile_translations:
	cd $(THEME_NAME) && i18n_tool generate

detect_changed_source_translations:
	cd $(THEME_NAME) && i18n_tool changed

dummy_translations:
	cd $(THEME_NAME) && i18n_tool dummy

extract_translations: ## extract strings to be translated, outputting .po files
	cd $(THEME_NAME) && i18n_tool extract --no-segment

generate_translations: extract_translations dummy_translations compile_translations

base_requirements:
	pip install -r ./requirements/base.txt

# This Make target should not be removed since it is relied on by a Jenkins job (`edx-internal/tools-edx-jenkins/translation-jobs.yml`), using `ecommerce-scripts/transifex`.
pull_translations: ## Pull translations from Transifex
	tx pull -t -a -f --mode reviewed --minimum-perc=1

# This Make target should not be removed since it is relied on by a Jenkins job (`edx-internal/tools-edx-jenkins/translation-jobs.yml`), using `ecommerce-scripts/transifex`.
push_translations: ## Push source translation files (.po) to Transifex
	tx push -s

requirements: base_requirements
	npm install

test:
	# Confirm compiled assets have not changed, indicating SASS matches CSS.
	git diff --exit-code $(THEME_NAME)/ ":(exclude)$(THEME_NAME)/conf"

upgrade: export CUSTOM_COMPILE_COMMAND=make upgrade
upgrade: ## update the requirements/*.txt files with the latest packages satisfying requirements/*.in
	pip install -q -r requirements/pip_tools.txt
	pip-compile --upgrade --rebuild --allow-unsafe -o requirements/pip.txt requirements/pip.in
	pip-compile --upgrade -o requirements/pip_tools.txt requirements/pip_tools.in
	pip install -qr requirements/pip.txt
	pip install -qr requirements/pip_tools.txt
	pip-compile --upgrade -o requirements/base.txt requirements/base.in
	pip-compile --upgrade -o requirements/test.txt requirements/test.in

validate_translations: generate_translations detect_changed_source_translations
	cd edx_credentials_themes && i18n_tool validate

install_transifex_client: ## Install the Transifex client
	curl -o- https://raw.githubusercontent.com/transifex/cli/master/install.sh | bash
	git checkout -- LICENSE README.md
