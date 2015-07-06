#lang racket
(require "gui.rkt"
         "ops.rkt")
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

(define-syntax-rule (form name clause ...)
  (begin
    (define name (make-gui 'name)) ; create a container
    (form-clause name #t clause) ...
    (send name start))) ; show the container

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

(define-syntax-rule (form-clause* form-name guard-expr [id question type compute-expr])
  (begin
    (define id undefined)
    (gui-add! form-name ; container
              type      ; widget
              question  ; label
              (lambda () guard-expr) ;guard
              (lambda (v) (set! id v)) ; set value
              compute-expr)))
