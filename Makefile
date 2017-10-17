.DEFAULT_GOAL := test
NODE_BIN=$(CURDIR)/node_modules/.bin

build:
	$(NODE_BIN)/webpack --config webpack.config.js --display-error-details --progress --optimize-minimize

build.watch:
	$(NODE_BIN)/webpack --config webpack.config.js --display-error-details --progress --watch

compile_translations:
	cd edx_credentials_themes && django-admin.py compilemessages

extract_translations:
	cd edx_credentials_themes && django-admin.py makemessages -l en -d django

i18n_requirements:
	pip install -r ./requirements/i18n.txt

requirements:
	npm install

test:
	# Confirm compiled assets have not changed, indicating SASS matches CSS.
	git diff --exit-code edx_credentials_themes/
