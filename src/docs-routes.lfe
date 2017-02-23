(defmodule docs-routes
  (export all))

(defun site ()
  (poise:site
    `(("index.html"
        ,(lambda () (docs-pages:get-page 'landing)))
      ("design/bootstrap.html"
        ,(lambda () (docs-pages:get-page 'bootstrap))))
    #m(output-dir "docs")))
