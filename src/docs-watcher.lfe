(defmodule docs-watcher
  (export all))

(defun source-data ()
  `#("src" ,#'lfe-watcher/1))

(defun template-data ()
  `#("priv/templates" ,#'erlydtl-watcher/1))

(defun default-watch-data ()
  `(,(template-data)
    ,(source-data)))

(defun lfe-compile (path file)
  (let ((outdir (get-ebin-dir file))
        (mod-name (get-module-name file))
        (filename (filename:join path file)))
    (code:purge mod-name)
    (logjam:info "Recompiling LFE file ~p ..." `(,filename))
    (case (lfe_comp:file filename `(#(outdir ,outdir)))
      (`#(ok ,_)
        (logjam:debug "Success.")
        (logjam:debug "Reloading module ~p ..." `(,mod-name))
        (case (code:load_file mod-name)
          (`#(module ,_) (logjam:debug "Success."))
          (err (logjam:debug "Couldn't reload module: ~p" `(,err)))))
      (err (logjam:error "Couldn't compile file: ~p" `(,err))))))

(defun lfe-compiler (path file)
  (let ((`#(,source-dir ,watcher) (source-data)))
    (inotify:unwatch source-dir)
    (lfe-compile path file)
    (inotify:watch source-dir watcher)))

(defun lfe-watcher
  ((`#(,path file close_write ,fd ,file))
    (lfe-compiler path file))
  ((args)
    (logjam:debug "Unhandled LFE watcher event: ~p" `(,args))))

(defun erlydtl-compile (path file)
  (let* ((opts (get-erlydtl-opts))
         (outdir (get-ebin-dir file opts))
         (all-opts (++ opts `(#(out_dir ,outdir))))
         (suffix (get-tmpl-suffix opts))
         (mod-name (get-module-name file opts))
         (filename (filename:join path file)))
    (code:purge mod-name)
    (logjam:debug "Recompiling ErlyDTL file: ~p" `(,filename))
    (logjam:debug "All compile opts: ~p~n" `(,all-opts))
    (case (erlydtl:compile_file filename mod-name all-opts)
      (`#(ok ,_mod ,_msgs)
        (logjam:debug "Success.")
        (logjam:debug "Reloading module ~p ..." `(,mod-name))
        ;; Reloads are noisy with logs, so let's shutdown the logger until
        ;; we've finished
        (logjam:set-level 'critical)
        (case (code:load_file mod-name)
          (`#(module ,_) (logjam:debug "Success."))
          (err (logjam:debug "Couldn't reload module: ~p" `(,err))))
        (logjam:set-level 'info))
      (err (logjam:error "Couldn't compile file: ~p" `(,err))))))

(defun erlydtl-compiler (path file)
  (let ((`#(,template-dir ,watcher) (template-data))
        (filename (filename:join path file))
        (wildcard (filename:join path "*.html")))
    (inotify:unwatch template-dir)
    (erlydtl-compile path file)
    ;; Now let's compile all the othter templates, since they might
    ;; depend upon the once that's just changed
    (lists:map
      (lambda (filename)
        (erlydtl-compile path (filename:basename filename)))
      (lists:subtract (filelib:wildcard wildcard) `(,filename)))
    ;; Finally, re-render the pages with the recompiled templates
    (logjam:info "Re-rendering pages ...")
    (docs:gen-dev)
    (inotify:watch template-dir watcher)
    (docs-dev:restart-server)))

(defun erlydtl-watcher
  ((`#(,path file close_write ,fd ,file))
    (erlydtl-compiler path file))
  ((args)
    (logjam:debug "Unhandled ErlyDTL watcher event: ~p" `(,args))))

(defun start ()
  (start (default-watch-data)))

(defun start (watch-data)
  (logjam:start)
  (docs-gen:run-dev)
  (application:ensure_all_started 'inets)
  (docs-dev:serve)
  (application:ensure_all_started 'inotify)
  (application:ensure_all_started 'docs)
  (docs:start)
  (case (lists:map (match-lambda ((`#(,path ,func))
                     (logjam:debug "Watching path: ~p with function: ~p"
                                   `(,path ,func))
                     (inotify:watch path func)))
                   watch-data)
    ('(ok ok) 'ok)
    (err (logjam:error err))))

(defun stop ()
  (docs-dev:stop-server)
  (application:stop 'ets_manager)
  (application:stop 'inotify)
  (application:stop 'docs)
  (docs:stop))

(defun restart ()
  (stop)
  (timer:sleep 500)
  (start))

(defun get-module-name (filename)
  (clj:-> filename
          (filename:rootname)
          (list_to_atom)))

(defun get-module-name (filename opts)
  (clj:->> opts
           (get-tmpl-suffix)
           (++ (filename:rootname filename))
           (list_to_atom)))

(defun get-ebin-dir (filename)
  (clj:-> filename
          (get-module-name)
          (code:which)
          (filename:dirname)))

(defun get-ebin-dir (filename opts)
  (clj:->> opts
           (get-module-name filename)
           (code:get_object_code)
           (element 3)
           (filename:dirname)))

(defun get-erlydtl-opts ()
  (case (file:consult "rebar.config")
    (`#(ok ,data)
      (proplists:get_value 'erlydtl_opts data))))

(defun get-tmpl-suffix (opts)
  (proplists:get_value 'module_ext opts))
