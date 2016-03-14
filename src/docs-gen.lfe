(defmodule docs-gen
  (export all))

(defun start (cfg)
  (let ((build-dir (docs-cfg:get-in '(site-gen build-dir) cfg)))
    (logjam:info "Generating site at ~p" `(,build-dir))
    'noop))
