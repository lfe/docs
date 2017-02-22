(defmodule docs-routes
  (export all))

(defun site ()
  (poise:site
    `(("index.html" ,#'docs-pages:index/0))
    #m(output-dir "docs")))
