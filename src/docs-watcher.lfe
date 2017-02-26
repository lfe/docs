(defmodule docs-watcher
  (export all))

(defun source-data ()
  `#("src" ,#'docs-watcher:lfe-watcher/1))

(defun template-data ()
  `#("priv/templates" ,#'docs-watcher:erlydtl-watcher/1))

(defun default-watch-data ()
  `(,(source-data)
    ,(template-data)))

(defun lfe-watcher
  ((`#(,path file close_write ,fd ,file))
    (docs-compiler:lfe path file (source-data)))
  ((args)
    (logjam:debug "Unhandled LFE watcher event: ~p" `(,args))))

(defun erlydtl-watcher
  ((`#(,path file close_write ,fd ,file))
    (docs-compiler:erlydtl path file (template-data)))
  ((args)
    (logjam:debug "Unhandled ErlyDTL watcher event: ~p" `(,args))))

(defun start ()
  (start (default-watch-data)))

(defun start (watch-data)
  (logjam:start)
  (docs-gen:run-dev)
  (docs-httpd:start)
  (application:ensure_all_started 'inotify)
  (application:ensure_all_started 'docs)
  (docs:start)
  (case (lists:map (match-lambda ((`#(,path ,func))
                     (logjam:info "Watching path: ~p with function: ~p"
                                   `(,path ,func))
                     (inotify:watch path func)))
                   watch-data)
    ('(ok ok) 'ok)
    (err (logjam:error err))))

(defun stop ()
  (docs:stop)
  (application:stop 'docs)
  (application:stop 'ets_manager)
  (application:stop 'inotify)
  (docs-httpd:stop)
  ;; XXX add the following to logjam
  ;(logjam:stop)
  )

(defun restart ()
  (stop)
  (timer:sleep 500)
  (start))
