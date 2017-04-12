.DEFAULT_GOAL := test
NODE_BIN=$(CURDIR)/node_modules/.bin

build:
	$(NODE_BIN)/webpack --config webpack.config.js --display-error-details --progress --optimize-minimize

build.watch:
	$(NODE_BIN)/webpack --config webpack.config.js --display-error-details --progress --watch

requirements:
	npm install

test:
	# Confirm compiled assets have not changed, indicating SASS matches CSS.
	git diff --exit-code
