#lang racket/base
(require "send.rkt"
         (only-in "raw.rkt" lookup-method))

(provide class
         make-object
         get-field
         set-field!
         send
         with-method)

(define-syntax-rule (with-method ([name (obj-expr method-name)])
                      body ...)
  (let ([obj obj-expr])
    (let ([method (lookup-method obj 'method-name)])
      (let-syntax ([name
                    (syntax-rules ()
                      [(_ arg (... ...))
                       (method obj arg (... ...))])])
        body ...))))


