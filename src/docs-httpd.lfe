(defmodule docs-httpd
  (export all))

(defun handler (request)
  (logjam:info "Handling request for: ~s"
             `(,(element 8 request)))
  request)

(defun -start ()
  (application:ensure_all_started 'inets)
  (barista:start #'handler/1))

(defun -stop ()
  (barista:stop)
  ;; XXX update barista to do the following
  (erlang:unregister 'lmug-handler)
  (application:stop 'inets))

(defun start ()
  (logjam:info "Starting HTTP server ...")
  (-start))

(defun stop ()
  (logjam:info "Stopping HTTP server ...")
  (-stop))

(defun restart ()
  (logjam:info "Restarting HTTP server ...")
  (-stop)
  (-start))
