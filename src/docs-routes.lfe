(defmodule docs-nav
  (export all))

(defun site ()
  (poise:site
    '(("index.html" #'landing-tmpl:render/0))
    #(output-dir "docs")))
