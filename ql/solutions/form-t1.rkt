#lang racket
(require "gui.rkt"
         "ops.rkt"
         "has-type.rkt"
         (for-syntax syntax/parse))
(provide form
         (rename-out [when* when]
                     [boolean-widget boolean]
                     [money-widget money]
         
                     [-/coerce -]
                     [>/coerce >]
                     [</coerce <]
                     [=/coerce =]
                     [and/coerce and]
                     [or/coerce or])
         #%app
         #%datum
         #%module-begin)

(define-syntax form
  (lambda (stx)
    (syntax-parse stx
      [(form name clause ...)
       (unless (identifier? #'name)
         (raise-syntax-error 'form
                             "expected an identifier for the form"
                             #'name))
       #'(begin
           (define name (make-gui 'name))
           (form-clause name #t clause) ...
           (send name start))])))

(define-syntax form-clause
  (syntax-rules (when*)
    [(_ form-name guard-expr [id question type])
     (form-clause* form-name guard-expr [id question type #f])]
    [(_ form-name guard-expr [id question type compute-expr])
     (form-clause* form-name guard-expr [id question type (lambda () (check-type compute-expr type))])]
    [(_ form-name guard-expr (when* expr clause ...))
     (begin
       (form-clause form-name (and guard-expr (?/coerce (check-type expr boolean))) clause)
       ...)]))

(define-syntax form-clause*
  (lambda (stx)
    (syntax-parse stx
      [(_ form-name guard-expr [id question type compute-expr])
       (unless (identifier? #'id)
         (raise-syntax-error 'form
                             "expected an identifier for the question; found something else"
                             #'id))
       (unless (string? (syntax-e #'question))
         (raise-syntax-error 'form
                             "expected an string for the question; found something else"
                             #'question))
       #'(begin
           (define val-id undefined)
           (define-typed id val-id type)
           (gui-add! form-name
                     type
                     question
                     (lambda () guard-expr)
                     (lambda (v) (set! val-id v))
                     compute-expr))])))

(define-syntax when*
  (lambda (stx)
    (raise-syntax-error #f
                        "misuse of keyword"
                        stx)))
