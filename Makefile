PROJECT = docs
ROOT_DIR = $(shell pwd)
REPO = $(shell git config --get remote.origin.url)
LFE = _build/dev/lib/lfe/bin/lfe
ERL_LIBS = $(shell find ./_build/*/* -maxdepth 1 -mindepth 1 -exec printf "%s:" {} \;)
RIGHT_PAREN = )
LOCAL_DOCS_HOST = $(subst $(RIGHT_PAREN),,$(strip $(lastword $(shell grep host lfe.config))))
LOCAL_DOCS_PORT = $(subst $(RIGHT_PAREN),,$(strip $(lastword $(shell grep port lfe.config))))

include priv/make/base.mk
include priv/make/gen.mk
include priv/make/git.mk
