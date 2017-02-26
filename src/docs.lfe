(defmodule docs
  (behaviour gen_server)
  (export
    ;; gen_server implementation
    (start 0)
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

;; XXX how much responsibility for whole-app startup should these have?
;;     do we want to use these for docs-watcher too?
(defun start ()
  (logjam:start)
  (let ((cfg (initial-state)))
    (logjam:info "Starting docs gen-server ...")
    (gen_server:start (register-name)
                      (callback-module)
                      cfg
                      (genserver-opts))))

(defun stop ()
  (logjam:info "Stopping docs gen-server ...")
  (gen_server:call (server-name) 'stop)
  (gen_server:stop (server-name)))

(defun restart ()
  (stop)
  (start))

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
