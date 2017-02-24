PROJECT = docs
ROOT_DIR = $(shell pwd)
REPO = $(shell git config --get remote.origin.url)
LFE = _build/dev/lib/lfe/bin/lfe
SASS_DIR = priv/sass
DOCS_BUILD_DIR = $(ROOT_DIR)/docs/current
DEV_DOCS_BUILD_DIR = $(ROOT_DIR)/docs/dev
CSS_BUILD_DIR = $(DOCS_BUILD_DIR)/css
DEV_CSS_BUILD_DIR = $(DEV_DOCS_BUILD_DIR)/css
ERL_LIBS = $(shell find ./_build/*/lib -maxdepth 1 -mindepth 1 -exec printf "%s:" {} \;)

sass:
	sudo gem update --system
	sudo gem install sass

compile:
	rebar3 as dev compile

check:
	@rebar3 as test eunit

repl: compile
	@ERL_LIBS=$(ERL_LIBS) $(LFE)

shell:
	@rebar3 as dev shell

clean:
	@rebar3 clean
	@rm -rf ebin/* _build/default/lib/$(PROJECT)

clean-all: clean
	@rebar3 as dev lfe clean

css:
	@echo "\nGenerating minimized and regular versions of CSS files ..."
	@echo
	@sass --style compressed $(SASS_DIR)/lfe-theme.scss \
	$(CSS_BUILD_DIR)/bootstrap-min.css
	@sass $(SASS_DIR)/lfe-theme.scss \
	$(CSS_BUILD_DIR)/bootstrap.css

dev-css:
	@echo "\nGenerating minimized and regular versions of CSS files ..."
	@echo
	@sass --style compressed $(SASS_DIR)/lfe-theme.scss \
	$(DEV_CSS_BUILD_DIR)/bootstrap-min.css
	@sass $(SASS_DIR)/lfe-theme.scss \
	$(DEV_CSS_BUILD_DIR)/bootstrap.css

docs: clean docs-clean compile $(DOCS_BUILD_DIR) css
	@echo "\nBuilding docs ..."
	@echo
	@ERL_LIBS=$(ERL_LIBS) erl -s docs -s docs gen-content -noshell -eval 'init:stop()'

docs-only: $(DOCS_BUILD_DIR)
	@echo "\nBuilding docs ..."
	@echo
	@ERL_LIBS=$(ERL_LIBS) erl -s docs -s docs gen-content -noshell -eval 'init:stop()'

devdocs: docs
	@echo "\nRunning docs server on http://$(LOCAL_DOCS_HOST):$(LOCAL_DOCS_PORT) ... (To quit, hit ^c twice)"
	@echo
	@ERL_LIBS=$(ERL_LIBS) erl -s docs -s docs gen-content -s docs httpd -noshell

devcss:
	@echo "\nRunning docs server on http://$(LOCAL_DOCS_HOST):$(LOCAL_DOCS_PORT) ... (To quit, hit ^c twice)"
	@echo
	@sass --watch $(SASS_DIR)/lfe-theme.scss:$(CSS_BUILD_DIR)/bootstrap-min.css &
	@ERL_LIBS=$(ERL_LIBS) erl -s docs -s docs gen-content -s docs httpd -noshell

publish-docs: docs
	@echo "\nPublishing docs ..."
	@echo
	@cd $(DOCS_BUILD_DIR) && git push -f $(REPO) master:gh-pages
	@make teardown-temp-repo

.PHONY: docs
