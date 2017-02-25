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
  (logjam:warn "Stopping HTTP server ...")
  (barista:stop))

(defun restart-server ()
  (stop-server)
  (serve))
