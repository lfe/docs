# LFE Documentation Site

[![][lfe-tiny]][lfe-large]

*Documentation source for Lisp Flavoured Erlang*


#### Contents

* [Introduction](#introduction-)
* [Goals](#goals-)
* [Dependencies](#dependencies-)
* [Building](#building-)
   * [With make](#with-make-)
   * [In the REPL](#in-the-repl-)
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

* http://docs.lfe.io/current/

And the current development work on the docs is published here:

* http://docs.lfe.io/dev/

Note that the latest dev version provides a drop-down menu in the top-nav for
accessing previous releases of the LFE Documentation.


## Goals [&#x219F;](#contents)

The aim of this project is twofold:

* Maintain the content for the LFE documentation site
* Maintain a tool (written in LFE) for generating the LFE docs site

The next release of the docs site and tooling is v3.1. All tickets
for the release are ulimately linked here:
 * https://github.com/lfe/docs/issues/95


## Dependencies [&#x219F;](#contents)

* Erlang
* `rebar3`

If you want to regenerate the CSS, you'll need `sass`:

* `sass` (use `make sass` to install; requires Ruby + `gem` to be
  installed)

## Building

There are two supported ways of building the LFE docs site and CSS:

* using `make` targets (which call erlang under the hood)
* running `docs` functions from the LFE REPL


### With `make` [&#x219F;](#contents)

To (re)generate the static files:

```bash
$ make docs-dev
```

That will build both the HTML files as well as the CSS.

To only build the HTML:

```bash
$ make docs-dev-only
```

To only build the CSS:

```bash
$ make css-dev
```

Additionally, a `make` target is provided which compiles everything fresh,
starts up a local dev HTTP server, and watches for changes in CSS, HTML
templates, and LFE code:

```bash
$ make serve-dev-watch
```

The CSS watcher is a backgrounded `sass` process, and not native LFE, so you
will need to kill it when you are done:

```bash
$ make css-unwatch
```


### In the REPL [&#x219F;](#contents)

To (re)generate the static files, start up an LFE REPL:

```bash
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

lfe> (docs:start)
ok
```

To generate the docs to dev:

```cl
lfe> (docs:gen-dev)
Created docs/dev/index.html.
...
ok
```

Or to generate the static files to prod (the `current` directory; this is
only done when promoting dev to stable):

```cl
lfe> (docs:gen)
Created docs/current/index.html.
...
ok
```

To run a local copy of the development server and view your work at
[http://localhost:8080](http://localhost:8080), run the following:

```bash
lfe> (docs:httpd)
ok
```

The CSS files are managed with [sass](http://sass-lang.com). After changing
values in the `priv/sass/lfe*.scss` files or in the
`priv/sass/lfe-sass/` subdirectories, you'll need to rebuild:

```bash
$ make css
```


## Contributing Content [&#x219F;](#contents)

This part of the documentation (and code, for that matter) is under very active
development and is changing regularly, but as it stands right now, the
following steps outline how to add new content to the LFE Documentation site.

**Preparation**

1. Fork this repository.
1. `git clone` your fork to your local machine and `cd` to the working
   directory of your clone. If you will be making CSS changes, you'll need the
   `bootstrap-sass` submodule. In that case, you'll want to use
   `git clone --recursive`.
1. If you plan on making content additions, you'll want to select the
   template you want to base your page on (e.g., `priv/templates/base.html`).

**Content Creation**

1. Create a new template that extends your selected template, overriding the
   block with content in your new template (see the other templates for
   examples of this).
1. Update the `docs-pages:get-page` function with a clause that will match your
   page
   1. If you need a custom data function that sets variables that need to be
      substituted in your template, be sure to call it here in the `get-page`
      function (after you add it to `docs-data`).
   1. Also, in the `get-page` function is where you will call your template's
      `render` function.
   1. Make sure your `get-page` code extracts the results of the `render`
      function (e.g., using the provided `get-content` function in the same
      module).

**CSS Updates**

1. Make sure that your clone of `lfe/docs` has the submodule populated (check
   the `priv/sass/bootstrap-sass/` directory).
1. Make updates to the file `priv/sass/lfe-sass/bootstrap/_theme.scss`.
1. If you need to create some new variables, you'll want to edit
   `priv/sass/lfe-sass/bootstrap/_variables.scss`.
1. Commit your changes to the sass files.
1. Regenerate the dev CSS with `make css-dev`.

**Generation & Testing**

1. Start up the LFE REPL (e.g., `make repl`).
1. Generate the static content with `(docs:gen-dev)`.
1. Serve the newly generated content with `(docs:httpd)`.
1. Or do all of those with one target: `make serve-dev`.
1. Visit
   [http://localhost:8080/dev/index.html](http://localhost:8080/dev/index.html)
   and any other pages you need to test.
1. Once you are sure it's good, commit the changes.

*Caution*: Do not run `(docs:gen)`, as that will generate an updated stable
version of the docs (the contents of the `current`) directory. That is only
done prior to a new release of LFE and/or the documentation site. Any PRs that
update `current` will not be approved until those changes are removed (modulo
typo fixes and the like).

If you have called `(docs:gen)` by accident, simply do a `git checkout` of the
`current` dir to undo the docs regen.

**Submission**

1. Push to your fork on Github.
1. Open a PR.


## License [&#x219F;](#contents)

```
Copyright © 2013-2017 LFE Community

Distributed under the Apache License, Version 2.0.
```


[lfe-tiny]: priv/static/images/logos/lfe-tiny.png
[lfe-large]: priv/static/images/logos/lfe-large.png
