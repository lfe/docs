(defmodule docs-dev
  (export all))

(defun handler (request)
  (logjam:info "Handling request for: ~s"
             `(,(element 8 request)))
  request)

(defun serve ()
  (logjam:info "Starting HTTP server ...")
  (barista:start #'handler/1))

(defun stop-server ()
  (logjam:info "Stopping HTTP server ...")
  (barista:stop)
  ;; XXX update barista to do the following
  (erlang:unregister 'lmug-handler))

(defun restart-server ()
  (logjam:info "Restarting HTTP server ...")
  (barista:stop)
  (erlang:unregister 'lmug-handler)
  (barista:start #'handler/1))

