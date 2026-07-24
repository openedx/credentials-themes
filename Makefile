.DEFAULT_GOAL := help

.PHONY: help build build.watch compile_translations detect_changed_source_translations dummy_translations \
        extract_translations generate_translations base_requirements pull_translations \
        requirements test upgrade validate_translations

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
	uv sync --group dev
	uv tool install tox --with tox-uv

pull_translations: ## Pull translations via atlas
	# Remove existing translation directories
	find edx_credentials_themes/conf/locale -mindepth 1 -maxdepth 1 -type d -exec rm -r {} \;
	atlas pull $(ATLAS_OPTIONS) \
	           translations/credentials-themes/edx_credentials_themes/conf/locale:edx_credentials_themes/conf/locale
	make compile_translations

requirements: base_requirements
	npm install

npm_requirements:
	npm install

test:
	# Confirm compiled assets have not changed, indicating SASS matches CSS.
	git diff --exit-code $(THEME_NAME)/ ":(exclude)$(THEME_NAME)/conf"

upgrade: ## update python dependencies
	uv run --with edx-lint edx_lint write_uv_constraints pyproject.toml
	uv lock --upgrade

validate_translations: generate_translations detect_changed_source_translations
	cd edx_credentials_themes && i18n_tool validate
