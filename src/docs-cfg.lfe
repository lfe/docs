(defmodule docs-cfg
  (export all))

(include-lib "clj/include/compose.lfe")

(defun load-config ()
  (let ((cfg (lcfg-file:parse-local)))
    (++ cfg
        `(#(nav ,(load-nav cfg))))))

(defun load-nav (cfg)
  (-> cfg
      (docs-cfg:get-nav-file)
      (lcfg-file:read-file)
      (lcfg-file:parse-config)))

(defun get-nav-file (cfg)
  (get-in '(site-gen nav-file) cfg))

(defun get-in (keys cfg)
  (lists:foldl #'get/2 cfg keys))

(defun get (key config)
  ;; Note that when a keyfind returns false, we need to return an empty list
  ;; so that get-in's foldl will work at any depth.
  (case (lists:keyfind key 1 config)
    ('false '())
    (result (element 2 result))))
