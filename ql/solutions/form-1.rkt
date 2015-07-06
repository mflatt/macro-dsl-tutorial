#lang racket
(require "gui.rkt"
         "ops.rkt")

(define-syntax-rule (form name clause ...)
  (begin
    (define name (make-gui 'name)) ; create a container
    (form-clause name clause) ...
    (send name start))) ; show the container

(define-syntax-rule (form-clause form-name [id question type])
  (begin
    (define id undefined)
    (gui-add! form-name ; container
              type      ; widget
              question  ; label
              (lambda () #t) ; guard
              (lambda (v) (set! id v)) ; set value
              #f)))

; ----------------------------------------

(form Box1HouseOwning
      [hasSoldHouse "Did you sell a house in 2010?" boolean-widget]
      [sellingPrice "Price the house was sold for:" money-widget])
