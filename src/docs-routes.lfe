(defmodule docs-routes
  (export all))

(defun get-site (path)
  (poise:site
    `(("index.html"
        ,(lambda () (docs-pages:get-page 'landing path)))
      ("design/bootstrap.html"
        ,(lambda () (docs-pages:get-page 'bootstrap path))))
    `#m(output-dir ,(++ "docs" path))))

(defun dev-site ()
  "Generate the development site."
  (get-site "/dev"))

(defun site ()
  "Generate the production site."
  (get-site "/current"))
