(defmodule docs-data
  (export all))

(defun base (path)
  `(#(base_dir ,path)))

(defun frag
  (((= `(#(base_dir ,_)) data) fragment)
    (++ data
       `(#(fragment ,fragment))))
  ((path fragment)
    (frag (base path) fragment)))
