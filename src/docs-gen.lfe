(defmodule docs-gen
  (export all))

(defun run ()
  (poise:generate (docs-routes:site)))
