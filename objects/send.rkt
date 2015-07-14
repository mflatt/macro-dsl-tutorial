#lang racket/base
(require "raw.rkt"
         (for-syntax racket/base
                     syntax/parse))

(provide class
         make-object
         get-field
         set-field!
         send)

;; >>> define `send` <<<

