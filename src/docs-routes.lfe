(defmodule docs-routes
  (export all))

(defun get-routes (path)
  `(("index.html"
      ,(lambda () (docs-pages:get-page 'landing path)))
    ("design/bootstrap-theme.html"
      ,(lambda () (docs-pages:get-page 'bootstrap-theme path)))
    ("design/example-2-column.html"
     ,(lambda () (docs-pages:get-page 'example-two-column path)))
    ("community.html"
     ,(lambda () (docs-pages:get-page 'sub-page path)))))

(defun get-site (path)
  (poise:site
    (get-routes path)
    `#m(output-dir ,(++ "docs" path))))

(defun dev-site ()
  "Generate the development site."
  (get-site "/dev"))

(defun site ()
  "Generate the production site."
  (get-site "/current"))
