(defmodule docs-routes
  (export all))

(defun routes ()
  `(("index.html"
      ,(lambda () (docs-pages:get-page 'landing)))
    ("design/bootstrap.html"
      ,(lambda () (docs-pages:get-page 'bootstrap)))))

(defun dev-site ()
  "Generate the development site."
  (poise:site (routes) #m(output-dir "docs/dev")))

(defun site ()
  "Generate the production site."
  (poise:site (routes) #m(output-dir "docs/current")))
