(defmodule docs-dev
  (export all))

(defun handler (request)
  (io:format "Handling request for: ~s~n"
             `(,(element 8 request)))
  request)

(defun serve ()
  (barista:start #'handler/1))

(defun stop-server ()
  (barista:stop))
