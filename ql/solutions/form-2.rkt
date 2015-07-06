#lang racket
(require "gui.rkt"
         "ops.rkt")

(define-syntax-rule (form name clause ...)
  (begin
    (define name (make-gui 'name)) ; create a container
    (form-clause name clause) ...
    (send name start))) ; show the container

(define-syntax form-clause
  (syntax-rules ()
    [(_ form-name [id question type])
     (form-clause* form-name [id question type #f])]
    [(_ form-name [id question type compute-expr])
     (form-clause* form-name [id question type (lambda () compute-expr)])]))

(define-syntax-rule (form-clause* form-name [id question type compute-expr])
  (begin
    (define id undefined)
    (gui-add! form-name ; container
              type      ; widget
              question  ; label
              (lambda () #t) ;guard
              (lambda (v) (set! id v)) ; set value
              compute-expr)))

; ----------------------------------------

(form Box1HouseOwning
      [hasSoldHouse "Did you sell a house in 2010?" boolean-widget]
      [sellingPrice "Price the house was sold for:" money-widget]
      [privateDebt "Private debts for the sold house:" money-widget]
      [valueResidue "Value residue:" money-widget (-/coerce sellingPrice privateDebt)])
