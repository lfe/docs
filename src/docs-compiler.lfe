(defmodule docs-compiler
  (export all))

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

(defun lfe
  ((_ "docs.app.src" _)
    'skipping)
  ((path file `#(,source-dir ,watcher))
    (inotify:unwatch source-dir)
    (lfe-compile path file)
    (inotify:watch source-dir watcher)))

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

(defun erlydtl
  ((path file `#(,template-dir ,watcher))
    (let ((filename (filename:join path file))
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
      (docs-gen:run-dev)
      (inotify:watch template-dir watcher)
      (docs-httpd:restart))))

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
  (case (clj:-> filename
                (get-module-name)
                (code:which)
                (filename:dirname))
    ("." (get-ebin-dir "docs.lfe"))
    (dir dir)))

(defun get-ebin-dir (filename opts)
  (case (clj:->> opts
                 (get-module-name filename)
                 (code:get_object_code)
                 (element 3)
                 (filename:dirname))
    ("." (get-ebin-dir "docs.lfe" opts))
    (dir dir)))

(defun get-erlydtl-opts ()
  (case (file:consult "rebar.config")
    (`#(ok ,data)
      (proplists:get_value 'erlydtl_opts data))))

(defun get-tmpl-suffix (opts)
  (proplists:get_value 'module_ext opts))
