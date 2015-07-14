#lang racket/base
(require "send.rkt"
         (only-in "raw.rkt" lookup-method))

(provide class
         make-object
         get-field
         set-field!
         send
         with-method)

;; >>> define `with-method` <<<
