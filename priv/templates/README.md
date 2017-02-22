# LFE Docs Site Templates

These templates are ErlyDTL (Erlang Django Template Language) and are
automatically compiled when you run `rebar3 compile`.

1. LFE Docs expects its templates to be in `priv/templates`
1. LFE Docs expects template files to end in the `.html` extension

When LFE Docs ErlyDTL templates are compiled, several things happen:

1. An `.erl` source file is generated for each template, saved in the
   same directory as the template
1. A `.beam` file is saved to the default `ebin` directory for the project;
   note, however, that `-tmpl` is appended to the file name, e.g.: the
   template `base.html` is compiled to `base-tmpl.beam`
1. The compiled `.beam` file exports the `render/{0,1,2}` functions. These are
   what LFE Docs uses to generate the site content from the templates.
