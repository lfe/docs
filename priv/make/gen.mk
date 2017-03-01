SASS_DIR = priv/sass
DOCS_ROOT = $(ROOT_DIR)/docs
DOCS_STABLE_BUILD_DIR = $(DOCS_ROOT)/current
DOCS_DEV_BUILD_DIR = $(DOCS_ROOT)/dev
SASS = bundle exec sass --no-cache -f --trace
SASS_MIN = $(SASS) --style compressed
SASS_WATCH = bundle exec sass --no-cache --watch --trace

sass:
	sudo gem update --system
	sudo gem install bundler
	@cd $(SASS_DIR) && bundler install --path=.

css:
	@echo "\nGenerating minimized and regular versions of CSS files for $(DEPLOYMENT) ..."
	@echo
	@cd $(SASS_DIR) && $(SASS_MIN) lfe-$(DEPLOYMENT).scss \
		$(DOCS_ROOT)/$(DEPLOYMENT)/css/bootstrap-min.css
	@cd $(SASS_DIR) && $(SASS) lfe-$(DEPLOYMENT).scss \
		$(DOCS_ROOT)/$(DEPLOYMENT)/css/bootstrap.css
	@echo "Done.\n"

css-dev: DEPLOYMENT = dev
css-dev: css

css-stable: DEPLOYMENT = current
css-stable: css

css-1.3: DEPLOYMENT = v1.3
css-1.3: css

css-watch: DEPLOYMENT = dev
css-watch:
	@cd $(SASS_DIR) && \
	$(SASS_WATCH) \
	lfe-$(DEPLOYMENT).scss:$(DOCS_ROOT)/$(DEPLOYMENT)/css/bootstrap-min.css &

css-watch-dev: DEPLOYMENT = dev
css-watch-dev: css-watch

css-unwatch:
	@killall sass

docs-header:
	@echo "\nBuilding docs ..."
	@echo

docs-dev-only: docs-header
	@ERL_LIBS=$(ERL_LIBS) $(LFE) -e '(docs-cli:gen-dev)'

docs-stable-only: docs-header
	@ERL_LIBS=$(ERL_LIBS) $(LFE) -e '(docs-cli:gen-stable)'

docs-dev: docs-header clean compile css-dev docs-dev-only

docs-stable: docs-header clean compile css-stable docs-stable-only

serve-header:
	@echo "\nRunning docs server on http://$(LOCAL_DOCS_HOST):$(LOCAL_DOCS_PORT) ... (To quit, hit ^c twice)"
	@echo

serve-only:
	@ERL_LIBS=$(ERL_LIBS) erl -s docs-cli start-httpd -noshell

serve: compile serve-header serve-only

serve-watch-css: serve-header css-watch-dev serve-only

serve-dev: docs-header clean compile css-dev serve-header
	@ERL_LIBS=$(ERL_LIBS) $(LFE) -s docs-cli gen-dev-httpd

serve-dev-watch: docs-header clean compile css-dev css-watch-dev serve-header
	@ERL_LIBS=$(ERL_LIBS) $(LFE) -s docs-cli gen-dev-watch

contributors:
	git log --pretty=format:"%an"|sort -u

.PHONY: docs
