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

i18n_requirements:
	pip install -r ./requirements/i18n.txt

requirements: i18n_requirements
	npm install

test:
	# Confirm compiled assets have not changed, indicating SASS matches CSS.
	git diff --exit-code edx_credentials_themes/

validate_translations: generate_translations detect_changed_source_translations
	cd edx_credentials_themes && i18n_tool validate
