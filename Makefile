PROJECT = docs
ROOT_DIR = $(shell pwd)
REPO = $(shell git config --get remote.origin.url)
LFE = _build/dev/lib/lfe/bin/lfe
ERL_LIBS = $(shell find ./_build/*/lib -maxdepth 1 -mindepth 1 -exec printf "%s:" {} \;)

include priv/make/base.mk
include priv/make/gen.mk
include priv/make/git.mk
