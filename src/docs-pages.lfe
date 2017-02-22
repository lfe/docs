(defmodule docs-pages
  (export all))

(defun index ()
  (case (landing-tmpl:render)
    (`#(ok ,page) page)
    (err err)))
