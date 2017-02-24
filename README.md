# LFE Documentation Site

[![][lfe-tiny]][lfe-large]


*Documentation source for Lisp Flavoured Erlang*


#### Contents

* [Introduction](#introduction-)
* [Goals](#goals-)
* [Dependencies](#dependencies-)
* [Building](#building-)
* [Contributing Content](#contributing-content-)
* [License](#license-)


## Introduction [&#x219F;](#contents)

> When I first came here, this was all yak hair. Everyone said I was daft to
> build a yurt on the Endless High Plain of Yak, but I built in all the same,
> just to show them. It sank into the Plains of Yak. So I built a second one.
> That sank into the Plains of Yak. So I built a third. That burned down, fell
> over, then sank into the Plains of Yak. But the fourth one stayed up. And
> that's what you're going to get, the strongest yak hair yurt on the Endless
> High Plain of Yak.

Build for failure? No! Build to burn down, fall over, and sink into the Plains
of Yak!

This is the source code that generates the site for the LFE documentation.
The last stable release is always available here:

* http://docs3.lfe.io/current/

And the current development release for the docs is here:

* http://docs3.lfe.io/dev/

The dev version provides a drop-down menu in the top-nav for accessing
previous releases of the LFE Documentation.


## Goals [&#x219F;](#contents)

The aim of this project is to produce a tool that we can use to generate the
LFE docs site without having to rely on Ruby or Github's gh-pages features
(which we have not been entirely happy with; but hey, you can't please all the
people all the time ... espeically the fringe Lispers who write distributed
systems).

The details behind this aim are outlined in a series of epic tickets (as well
as in various emails on the LFE mail list) linked here in this meta- epic (oh
yeah, we took it up a level):

* [https://github.com/lfe/docs/issues/62](https://github.com/lfe/docs/issues/62)

v3 of the LFE docs site has been forked from v1. It will use some of the CSS
of v2 (heavily borrowing from Github's API site), and when done, should be
able to be merged back into the regular docs site (thus preserving the
contributions made by community members to-date).


## Dependencies [&#x219F;](#contents)

* Erlang
* `rebar3`

If you want to regenerate the CSS, you'll need `sass`:

* `sass` (use `make sass` to install; requires Ruby + `gem` to be
  installed)


## Building [&#x219F;](#contents)

The CSS files are managed with [sass](http://sass-lang.com). After changing
values in `priv/sass/lfe-theme.scss` (or in the
`priv/sass/_variables.scss` file), you'll need to rebuild:

```bash
$ make css
```

To (re)generate the static files, start up an LFE REPL:

```
$ make repl
```
```
Erlang/OTP 18 [erts-7.3] [source] [64-bit] [smp:4:4] [async-threads:10] ...

   ..-~.~_~---..
  (      \\     )    |   A Lisp-2+ on the Erlang VM
  |`-.._/_\\_.-':    |   Type (help) for usage info.
  |         g |_ \   |
  |        n    | |  |   Docs: http://docs.lfe.io/
  |       a    / /   |   Source: http://github.com/rvirding/lfe
   \     l    |_/    |
    \   r     /      |   LFE v1.3-dev (abort with ^G)
     `-E___.-'

lfe>
```

To generate the docs to dev:

```cl
lfe> (docs-gen:run-dev)
Created docs/dev/index.html.
...
ok
```

Or to generate the static files to prod (the `current` directory):

```cl
lfe> (docs-gen:run)
Created docs/current/index.html.
...
ok
```

To run a local copy of the development server and view your work at
[http://localhost:8080](http://localhost:8080), run the following:

```bash
lfe> (docs-dev:serve)
ok
```


## Contributing Content [&#x219F;](#contents)

TBD


## License [&#x219F;](#contents)

```
Copyright © 2013-2016 LFE Community

Distributed under the Apache License, Version 2.0.
```


[lfe-tiny]: priv/static/images/logos/lfe-tiny.png
[lfe-large]: priv/static/images/logos/lfe-large.png
