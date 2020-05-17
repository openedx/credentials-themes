.DEFAULT_GOAL := test
NODE_BIN=$(CURDIR)/node_modules/.bin

build:
	$(NODE_BIN)/webpack --config webpack.config.js --display-error-details --progress --optimize-minimize

build.watch:
	$(NODE_BIN)/webpack --config webpack.config.js --display-error-details --progress --watch

compile_translations:
	cd edx_credentials_themes && django-admin.py compilemessages

detect_changed_source_translations:
	cd edx_credentials_themes && i18n_tool changed

dummy_translations:
	cd edx_credentials_themes && i18n_tool dummy

extract_translations:
	cd edx_credentials_themes && django-admin.py makemessages -l en -d django

generate_translations: extract_translations dummy_translations compile_translations

base_requirements:
	pip install -r ./requirements/base.txt

pull_translations:
	tx pull -af --mode reviewed

requirements: base_requirements
	npm install

test:
	# Confirm compiled assets have not changed, indicating SASS matches CSS.
	git diff --exit-code edx_credentials_themes/

upgrade: export CUSTOM_COMPILE_COMMAND=make upgrade
upgrade: ## update the requirements/*.txt files with the latest packages satisfying requirements/*.in
	pip install -q -r requirements/pip_tools.txt
	pip-compile --upgrade -o requirements/pip_tools.txt requirements/pip_tools.in
	pip-compile --upgrade -o requirements/base.txt requirements/base.in
	pip-compile --upgrade -o requirements/test.txt requirements/test.in
	pip-compile --upgrade -o requirements/travis.txt requirements/travis.in

validate_translations: generate_translations detect_changed_source_translations
	cd edx_credentials_themes && i18n_tool validate
