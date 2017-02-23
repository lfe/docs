(defmodule docs-pages
  (export all))

(defun get-content
  ((`#(ok ,page)) page)
  ((err) err))

(defun get-page
  (('landing path)
    (get-content (landing-tmpl:render `(#(base_dir ,path)))))
  (('bootstrap path)
    (get-content (theme-tmpl:render `(#(base_dir ,path))))))
