##
# Kore Make
# Copyright(c) 2014 Koreviz
# MIT Licensed
##
SHELL := /bin/bash

APP = orion
VERSION = v1.0.0
PUG = $(shell find node_modules/pug-cli -maxdepth 1 -name "index.js" -type f)
OPTIONS = { "filename": " ", "title": "Kore", "description": "", "keywords": "" }
NIB = $(shell find node_modules/nib/lib -name "nib" -type d)
PAGES = index.pug our-story.pug partners.pug store.pug contact.pug
REPO = koreviz/$(APP)
SERVE = $(shell find node_modules -name "serve" -type f)
STYLUS = $(shell find node_modules -maxdepth 3 -name "stylus" -type f)
UGLIFYJS = $(shell find node_modules/uglify-js -name "uglifyjs" -type f)

all: configure compile

clean:
	rm -fR node_modules
	rm -fR public/{components,fonts}
	rm -f public/*.html
	rm -f public/script/*.js
	rm -f public/style/*.css

configure:
	npm install
	mkdir -p ./public/{script,style}

	bower install

compile:
	$(foreach script,$(shell find script -name "*.js" -type f),$(UGLIFYJS) -o public/script/$(notdir $(script)) $(script);)
	$(foreach style,$(shell find style -name "*.styl" -type f),$(STYLUS) -u ./$(NIB) -c -o public/style $(style);)
	$(foreach page,$(PAGES),$(foreach view,$(shell find view -name "$(page)" -type f),$(PUG) $(view) -O '$(OPTIONS)' -o public;))

debug:
	$(foreach script,$(shell find script -name "*.js" -type f),cp -f $(script) public/script;)
	$(foreach style,$(shell find style -name "*.styl" -type f),$(STYLUS) -u ./$(NIB) -o public/style $(style);)
	$(foreach page,$(PAGES),$(foreach view,$(shell find view -name "$(page)" -type f),$(PUG) $(view) -O '$(OPTIONS)' -o public;))

package:
	export COPYFILE_DISABLE=true; tar czvf ../$(APP)-$(VERSION).tar.gz History.md public Readme.md

push:
	rm -fR .git
	git init
	git add .
	git commit -m "Initial release"
	git remote add origin gh:$(REPO).git
	git push origin master

serve:
	$(SERVE) -f ./public/favicon.ico ./public
