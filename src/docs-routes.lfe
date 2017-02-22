(defmodule docs-routes
  (export all))

(defun site ()
  (poise:site
    '(("index.html" (lambda () (docs-pages:index))))
    #m(output-dir "docs")))
