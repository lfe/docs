PROJECT = docs
ROOT_DIR = $(shell pwd)
REPO = $(shell git config --get remote.origin.url)
LFE = _build/default/lib/lfe/bin/lfe
DOCS_BUILD_DIR = $(ROOT_DIR)/master
SLATE_GIT_HACK = $(DOCS_DIR)/.git
LOCAL_DOCS_HOST = localhost
LOCAL_DOCS_PORT = 5099

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

$(SLATE_GIT_HACK): $(DOCS_BUILD_DIR)
	@ln -s $(ROOT_DIR)/.git $(DOCS_BUILD_DIR)

docs-clean:
	@echo "\nCleaning build directories ..."
	@rm -rf $(DOCS_BUILD_DIR)

docs: clean docs-clean compile $(SLATE_GIT_HACK)
	@echo "\nBuilding docs ...\n"

devdocs: docs
	@echo
	@echo "Running docs server on http://$(LOCAL_DOCS_HOST):$(LOCAL_DOCS_PORT) ... (To quit, hit ^c twice)"
	@echo
	@ERL_LIBS=`find ./_build/default/lib -maxdepth 1 -mindepth 1 -exec printf "%s:" {} \;` \
	erl -s docs -noshell

setup-temp-repo: $(SLATE_GIT_HACK)
	@echo "\nSetting up temporary git repos for gh-pages ...\n"
	@rm -rf $(DOCS_BUILD_DIR)/.git
	@cd $(DOCS_BUILD_DIR) && git init
	@cd $(DOCS_BUILD_DIR) && git add * > /dev/null
	@cd $(DOCS_BUILD_DIR) && git commit -a -m "Generated content." > /dev/null

teardown-temp-repo:
	@echo "\nTearing down temporary gh-pages repos ..."
	@rm $(DOCS_BUILD_DIR)/.git

publish-docs: docs setup-temp-repo
	@echo "\nPublishing docs ...\n"
	@cd $(DOCS_BUILD_DIR) && git push -f $(REPO) master:gh-pages
	@make teardown-temp-repo

.PHONY: docs
