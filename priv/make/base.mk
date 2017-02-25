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
	@rm -rf ebin/* _build/*/lib/$(PROJECT)

clean-all: clean
	@rebar3 as dev lfe clean
