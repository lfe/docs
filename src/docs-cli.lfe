(defmodule docs-cli
  (export all))

(defun do-cmd (cmd)
  (docs:start)
  (funcall cmd)
  (docs:stop))

(defun gen-stable ()
  (do-cmd #'docs:gen/0))

(defun gen-dev ()
  (do-cmd #'docs:gen-dev/0))

(defun httpd ()
  (do-cmd #'docs:httpd/0))

(defun gen-dev-httpd ()
  (do-cmd
    (lambda ()
      (docs:gen-dev)
      (docs:httpd))))
