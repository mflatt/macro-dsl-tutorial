#lang racket/base
(require "raw.rkt"
         (for-syntax racket/base
                     syntax/parse))

(provide class
         make-object
         get-field
         set-field!
         send)

;; Solution to 1:

(define-syntax-rule (send obj method-name arg ...)
  ((lookup-method obj 'method-name) obj arg ...))

;; Solution to 2 (replaces above):
#;
(define-syntax send
  (lambda (stx)
    (syntax-parse stx
      [(_ obj method-name arg ...)
       (unless (identifier? #'method-name)
         (raise-syntax-error #f "not an identifier" #'method-name))
       #'((lookup-method obj 'method-name) obj arg ...)])))
