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
    (code_change 3)
    ;; server API
    (gen 0)
    (gen-dev 0)
    (httpd 0)
    (httpd-restart 0)
    (httpd-stop 0)))

;;; config functions

(defun server-name () (MODULE))
(defun callback-module () (MODULE))
(defun initial-state () (docs-cfg:load-config))
(defun genserver-opts () '())
(defun register-name () `#(local ,(server-name)))
(defun unknown-command () #(error "Unknown command."))

;;; gen_server implementation

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
  (gen_server:call (server-name) 'stop))

;;; callback implementation

(defun init (initial-state)
  `#(ok ,initial-state))

(defun handle_cast
  (('gen state-data)
    `#(noreply ,(docs-gen:run)))
  (('gen-dev state-data)
    `#(noreply ,(docs-gen:run-dev)))
  (('httpd state-data)
    `#(noreply ,(docs-dev:serve)))
  (('httpd-restart state-data)
    `#(noreply ,(docs-dev:restart-server)))
  (('httpd-stop state-data)
    `#(noreply ,(docs-dev:stop-server))))

(defun handle_call
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

;;; our server API

(defun gen ()
  (gen_server:cast (server-name) 'gen))

(defun gen-dev ()
  (gen_server:cast (server-name) 'gen-dev))

(defun httpd ()
  (gen_server:cast (server-name) 'httpd))

(defun httpd-restart ()
  (gen_server:cast (server-name) 'httpd-restart))

(defun httpd-stop ()
  (gen_server:cast (server-name) 'httpd-stop))
