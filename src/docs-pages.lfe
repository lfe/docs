(defmodule docs-pages
  (export all))

(defun get-content
  ((`#(ok ,page)) page)
  ((err) err))

(defun get-page
  (('landing)
    (get-content (landing-tmpl:render)))
  (('bootstrap)
    (get-content (theme-tmpl:render))))
