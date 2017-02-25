(defmodule docs-pages
  (export all))

(defun get-content
  "This is a wrapper function that processes the result of an ErlyDTL template
  rendering, returning just the content."
  ((`#(ok ,page)) page)
  ((err) err))

(defun get-priv-dir ()
  (code:priv_dir 'docs))

(defun get-base-page (name)
  'noop)

(defun get-fragment-page (name)
  (file:read_file
    (filename:join `(,(get-priv-dir)
                     "html-fragments"
                     ,name))))

(defun get-page
  (('landing path)
    (clj:-> path
            (docs-data:base)
            (landing-tmpl:render)
            (get-content)))
  (('bootstrap-theme path)
    (clj:-> path
            (docs-data:base)
            (bootstrap-theme-tmpl:render)
            (get-content)))
  (('example-two-column path)
    (clj:-> path
            (docs-data:base)
            (example_two_column-tmpl:render)
            (get-content))))
