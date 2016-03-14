(defmodule docs-nav
  (export all))

(defun top-nav (cfg)
  (let ((nav-data (docs-cfg:get-top-nav cfg)))
    (lists:map #'process-nav-item/1 nav-data)))

(defun process-nav-item (item)
  item)
