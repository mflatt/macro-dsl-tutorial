#lang racket
(require "gui.rkt"
         "ops.rkt"
         (for-syntax syntax/parse))
(provide form
         (rename-out [boolean-widget boolean]
                     [money-widget money]
         
                     [-/coerce -]
                     [>/coerce >]
                     [</coerce <]
                     [=/coerce =]
                     [and/coerce and]
                     [or/coerce or])
         when
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
  (syntax-rules (when)
    [(_ form-name guard-expr [id question type])
     (form-clause* form-name guard-expr [id question type #f])]
    [(_ form-name guard-expr [id question type compute-expr])
     (form-clause* form-name guard-expr [id question type (lambda () compute-expr)])]
    [(_ form-name guard-expr (when expr clause ...))
     (begin
       (form-clause form-name (and guard-expr (?/coerce expr)) clause)
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
           (define id undefined)
           (gui-add! form-name
                     type
                     question
                     (lambda () guard-expr)
                     (lambda (v) (set! id v))
                     compute-expr))])))
