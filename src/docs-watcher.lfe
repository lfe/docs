(defmodule docs-watcher
  (export all))

(defun default-watch-data ()
  `(#("priv/templates" ,#'erlydtl-watcher/1)
    #("src" ,#'lfe-watcher/1)))

(defun lfe-compiler (filename)
  (logjam:info "Recompiling LFE file: ~p" `(,filename)))

(defun erlydtl-compiler (filename)
  (logjam:info "Recompiling ErlyDTL file: ~p" `(,filename)))

(defun lfe-watcher
  ((`#(,path file close_write ,fd ,file))
    (lfe-compiler (filename:join path file)))
  ((_arg)
    'skipping))

(defun erlydtl-watcher
  ((`#(,path file close_write ,fd ,file))
    (erlydtl-compiler (filename:join path file)))
  ((_) 'skipping))

(defun start ()
  (start (default-watch-data)))

(defun start (watch-data)
  (logjam:start)
  (application:ensure_all_started 'inotify)
  (case (lists:map (match-lambda ((`#(,path ,func))
                     (logjam:debug "Watching path: ~p with function: ~p"
                                   `(,path ,func))
                     (inotify:watch path func)))
                   watch-data)
    ('(ok ok) 'ok)
    (err (logjam:error err))))
