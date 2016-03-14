(defmodule docs-gen
  (export all))

(defun run (cfg)
  (let ((build-dir (docs-cfg:get-build-dir cfg)))
    (logjam:info "Generating site at ~p" `(,build-dir))
    (copy-static cfg)
    (logjam:debug "Completed build.")
    cfg))

(defun copy-static (cfg)
  (logjam:debug "Copying static content to build directory ...")
  (let ((src-dir (++ (docs-cfg:get-static-assets cfg) "/*"))
        (dst-dir (docs-cfg:get-build-dir cfg)))
    (os:cmd (++ "cp -r " src-dir " " dst-dir))))
