(defmodule docs-gen
  (export all))

(defun run-stable ()
  (poise:generate (docs-routes:site)))

(defun run-dev ()
  (poise:generate (docs-routes:dev-site)))
