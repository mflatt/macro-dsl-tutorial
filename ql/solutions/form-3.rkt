#lang racket
(require "gui.rkt"
         "ops.rkt")

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

; ----------------------------------------

(form Box1HouseOwning
      [hasSoldHouse "Did you sell a house in 2010?" boolean-widget]
      (when hasSoldHouse
        [sellingPrice "Price the house was sold for:" money-widget]
        [privateDebt "Private debts for the sold house:" money-widget]
        [valueResidue "Value residue:" money-widget (-/coerce sellingPrice privateDebt)]))
