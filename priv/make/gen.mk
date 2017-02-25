SASS_DIR = priv/sass
DOCS_ROOT = $(ROOT_DIR)/docs
DOCS_STABLE_BUILD_DIR = $(DOCS_ROOT)/current
DOCS_DEV_BUILD_DIR = $(DOCS_ROOT)/dev
SASS = sass --no-cache -f --trace
SASS_MIN = $(SASS) --style compressed
SASS_WATCH = sass --no-cache --watch --trace

sass:
	sudo gem update --system
	sudo gem install sass

css:
	@echo "\nGenerating minimized and regular versions of CSS files for $(DEPLOYMENT) ..."
	@echo
	@$(SASS_MIN) $(SASS_DIR)/lfe-$(DEPLOYMENT).scss \
		$(DOCS_ROOT)/$(DEPLOYMENT)/css/bootstrap-min.css
	@$(SASS) $(SASS_DIR)/lfe-$(DEPLOYMENT).scss \
		$(DOCS_ROOT)/$(DEPLOYMENT)/css/bootstrap.css
	@echo "Done.\n"

css-dev: DEPLOYMENT = dev
css-dev: css

css-stable: DEPLOYMENT = current
css-stable: css

css-1.3: DEPLOYMENT = v1.3
css-1.3: css

css-watch:
	@$(SASS_WATCH) $(SASS_DIR)/lfe-$(DEPLOYMENT).scss:$(DOCS_ROOT)/$(DEPLOYMENT)/css/bootstrap-min.css &

css-watch-dev: DEPLOYMENT = dev
css-watch-dev: css-watch

docs-header:
	@echo "\nBuilding docs ..."
	@echo

docs-dev-only: docs-header
	@ERL_LIBS=$(ERL_LIBS) erl -s docs-cli gen-dev -noshell -eval 'init:stop()'

docs-stable-only: docs-header
	@ERL_LIBS=$(ERL_LIBS) erl -s docs-cli gen-stable -noshell -eval 'init:stop()'

docs-dev: docs-header clean compile css-dev docs-dev-only

docs-stable: docs-header clean compile css-stable docs-stable-only

serve-header:
	@echo "\nRunning docs server on http://$(LOCAL_DOCS_HOST):$(LOCAL_DOCS_PORT) ... (To quit, hit ^c twice)"
	@echo

serve-only:
	@ERL_LIBS=$(ERL_LIBS) erl -s docs-cli httpd -noshell

serve: compile serve-header serve-only

serve-watch-css: serve-header css-watch-dev serve-only
	@ERL_LIBS=$(ERL_LIBS) erl -s docs -s docs gen-content -s docs httpd -noshell

serve-dev: docs-dev serve-watch-css

contributors:
	git log --pretty=format:"%an"|sort -u

.PHONY: docs
