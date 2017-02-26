(defmodule docs-watcher
  (export all))

(defun source-data ()
  `#("src" ,#'lfe-watcher/1))

(defun templates-data ()
  `#("priv/templates" ,#'erlydtl-watcher/1))

(defun default-watch-data ()
  `(,(templates-data)
    ,(source-data)))

(defun lfe-compiler (path file)
  (let ((`#(,source-dir ,watcher) (source-data))
        (outdir (get-ebin-dir file))
        (mod-name (get-module-name file))
        (filename (filename:join path file)))
    (inotify:unwatch source-dir)
    (code:purge mod-name)
    (logjam:info "Recompiling LFE file ~p ..." `(,filename))
    (case (lfe_comp:file filename `(#(outdir ,outdir)))
      (`#(ok ,_)
        (logjam:info "Success.")
        (logjam:info "Reloading module ~p ..." `(,mod-name))
        (case (code:load_file mod-name)
          (`#(module ,_) (logjam:info "Success."))
          (err (logjam:error "Couldn't reload module: ~p" `(,err)))))
      (err (logjam:error "Couldn't compile file: ~p" `(,err))))
    (inotify:watch source-dir watcher)))

(defun erlydtl-compiler (filename)
  (logjam:info "Recompiling ErlyDTL file: ~p" `(,filename))
  (docs:httpd-restart))

(defun lfe-watcher
  ((`#(,path file close_write ,fd ,file))
    (lfe-compiler path file))
  ((args)
    (logjam:debug "LFE watcher event: ~p" `(,args))))

(defun erlydtl-watcher
  ((`#(,path file close_write ,fd ,file))
    (erlydtl-compiler (filename:join path file)))
  ((args)
    (logjam:debug "ErlyDTL watcher event: ~p" `(,args))))

(defun start ()
  (start (default-watch-data)))

(defun start (watch-data)
  (docs:start)
  (docs:httpd)
  (application:ensure_all_started 'inotify)
  (case (lists:map (match-lambda ((`#(,path ,func))
                     (logjam:debug "Watching path: ~p with function: ~p"
                                   `(,path ,func))
                     (inotify:watch path func)))
                   watch-data)
    ('(ok ok) 'ok)
    (err (logjam:error err))))

(defun get-module-name (filename)
  (clj:-> filename
          (filename:rootname)
          (list_to_atom)))

(defun get-ebin-dir (filename)
  (clj:-> filename
          (get-module-name)
          (code:which)
          (filename:dirname)))
