compile:
	rebar3 compile

check:
	@rebar3 eunit

repl: compile
	@ERL_LIBS=$(ERL_LIBS) $(LFE)

shell:
	@rebar3 shell

clean:
	@rebar3 clean
	@rm -rf ebin/* _build/*/lib/$(PROJECT)
