PROJECT = docs
ROOT_DIR = $(shell pwd)
REPO = $(shell git config --get remote.origin.url)
LFE = _build/default/lib/lfe/bin/lfe
SASS_DIR = priv/sass
DOCS_BUILD_DIR = $(ROOT_DIR)/master
CSS_BUILD_DIR = $(DOCS_BUILD_DIR)/css
GHPAGES_GIT_HACK = $(DOCS_BUILD_DIR)/.git
LOCAL_DOCS_HOST = localhost
LOCAL_DOCS_PORT = 5099
ERL_LIBS = $(shell find ./_build/default/lib -maxdepth 1 -mindepth 1 -exec printf "%s:" {} \;)

sass:
	sudo gem update --system
	sudo gem install sass

compile:
	rebar3 compile

check:
	@rebar3 as test eunit

repl: compile
	@$(LFE)

shell:
	@rebar3 shell

clean:
	@rebar3 clean
	@rm -rf ebin/* _build/default/lib/$(PROJECT)

clean-all: clean
	@rebar3 as dev lfe clean

$(DOCS_BUILD_DIR):
	@mkdir -p $(DOCS_BUILD_DIR)

$(CSS_BUILD_DIR):
	@mkdir -p $(CSS_BUILD_DIR)

docs-clean:
	@echo "\nCleaning build directories ..."
	@rm -rf $(DOCS_BUILD_DIR)

css: $(CSS_BUILD_DIR)
	@echo "\nGenerating minimized and dev versions of CSS files ..."
	@echo
	@sass --style compressed $(SASS_DIR)/lfe-theme.scss $(CSS_BUILD_DIR)/bootstrap-min.css
	@sass $(SASS_DIR)/lfe-theme.scss $(CSS_BUILD_DIR)/bootstrap.css

docs: clean docs-clean compile $(DOCS_BUILD_DIR) css
	@echo "\nBuilding docs ..."
	@echo
	@ERL_LIBS=$(ERL_LIBS) erl -s docs -s docs gen-content -noshell -eval 'init:stop()'

devdocs: docs
	@echo "\nRunning docs server on http://$(LOCAL_DOCS_HOST):$(LOCAL_DOCS_PORT) ... (To quit, hit ^c twice)"
	@echo
	@ERL_LIBS=$(ERL_LIBS) erl -s docs -s docs gen-content -s docs httpd -noshell

setup-temp-repo: $(SLATE_GIT_HACK)
	@echo "\nSetting up temporary git repos for gh-pages ..."
	@echo
	@rm -rf $(DOCS_BUILD_DIR)/.git
	@cd $(DOCS_BUILD_DIR) && git init
	@cd $(DOCS_BUILD_DIR) && git add * > /dev/null
	@cd $(DOCS_BUILD_DIR) && git commit -a -m "Generated content." > /dev/null

teardown-temp-repo:
	@echo "\nTearing down temporary gh-pages repos ..."
	@echo
	@rm -rf $(DOCS_BUILD_DIR)/.git

publish-docs: docs setup-temp-repo
	@echo "\nPublishing docs ..."
	@echo
	@cd $(DOCS_BUILD_DIR) && git push -f $(REPO) master:gh-pages
	@make teardown-temp-repo

.PHONY: docs
