(defmodule docs-gen
  (export all))

(defun run ()
  (poise:generate (docs-routes:site)))

(defun run-dev ()
  (poise:generate (docs-routes:dev-site)))
