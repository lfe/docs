(defmodule docs
  (behaviour gen_server)
  (export
    ;; gen_server implementation
    (start 0)
    (start-gen-server 0)
    (start-gen-server 1)
    (stop 0)
    ;; callback implementation
    (init 1)
    (handle_call 3)
    (handle_cast 2)
    (handle_info 2)
    (terminate 2)
    (code_change 3)))

;;; config functions

(defun server-name () (MODULE))
(defun callback-module () (MODULE))
(defun initial-state () (docs-cfg:load-config))
(defun genserver-opts () '())
(defun register-name () `#(local ,(server-name)))
(defun unknown-command () #(error "Unknown command."))

;;; gen_server implementation

(defun start ()
  (start "Starting docs gen-server ..."))

(defun start (msg)
  (start #'logjam:info/1 msg))

(defun start (log-fn log-msg)
  (logjam:start)
  (application:ensure_all_started 'docs)
  (funcall log-fn `(,log-msg))
  (start-gen-server))

(defun start-gen-server ()
  (start-gen-server (initial-state)))

(defun start-gen-server (cfg)
  (gen_server:start (register-name)
                    (callback-module)
                    cfg
                    (genserver-opts)))

(defun stop ()
  (stop "Stopping docs gen-server ..."))

(defun stop (msg)
  (stop #'logjam:info/1 msg))

(defun stop (log-fn log-msg)
  (funcall log-fn `(,log-msg))
  (stop-gen-server)
  (application:stop 'docs))

(defun stop-gen-server ()
  (gen_server:call (server-name) 'stop)
  (gen_server:stop (server-name)))

(defun restart ()
  (stop (lambda (x) x) "")
  (start "Restarting docs gen-server ..."))

;;; callback implementation

(defun init (initial-state)
  `#(ok ,initial-state))

(defun handle_cast
  ((message state-data)
    `#(reply ,(unknown-command) ,state-data)))

(defun handle_call
  (('stop caller state-data)
    `#(reply stopping ,state-data))
  ((message _caller state-data)
    `#(reply ,(unknown-command) ,state-data)))

(defun handle_info
  ((`#(EXIT ,_pid normal) state-data)
   `#(noreply ,state-data))
  ((`#(EXIT ,pid ,reason) state-data)
   (logjam:error "Process ~p exited! (Reason: ~p)~n" `(,pid ,reason))
   `#(noreply ,state-data))
  ((_msg state-data)
   `#(noreply ,state-data)))

(defun terminate (reason _state-data)
  (logjam:info "Application terminating: ~p" `(,reason))
  'ok)

(defun code_change (_old-version state _extra)
  `#(ok ,state))
