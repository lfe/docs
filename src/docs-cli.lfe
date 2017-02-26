(defmodule docs-cli
  (export all))

(defun do-cmd (cmd)
  (docs:start)
  (funcall cmd)
  (docs:stop))

(defun gen-stable ()
  (do-cmd #'docs-gen:run-stable/0))

(defun gen-dev ()
  (do-cmd #'docs-gen:run-dev/0))

(defun start-httpd ()
  (do-cmd #'docs-httpd:start/0))

(defun gen-dev-httpd ()
  (do-cmd
    (lambda ()
      (docs-gen:run-dev)
      (docs-httpd:start))))

(defun gen-dev-watch ()
  (docs-watcher:start))
