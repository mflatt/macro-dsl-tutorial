#lang racket
(require "gui.rkt"
         "ops.rkt")

;(form Box1HouseOwning
;      [hasSoldHouse "Did you sell a house in 2010?" boolean-widget]
;      [hasBoughtHouse "Did you buy a house in 2010?" boolean-widget]
;      [hasMaintLoan "Did you enter a loan for maintenance/reconstruction?" boolean-widget]
; 
;      (when hasSoldHouse
;        [sellingPrice "Price the house was sold for:" money-widget]
;        [privateDebt "Private debts for the sold house:" money-widget]
;        [valueResidue "Value residue:" money-widget (-/coerce sellingPrice privateDebt)]))

(define Box1HouseOwning
  (make-gui 'Box1HouseOwning))

(define hasSoldHouse undefined)
(gui-add! Box1HouseOwning
          boolean-widget
          "Did you sell a house in 2010?"
          (lambda () #t) ; guard
          (lambda (v) (set! hasSoldHouse v))
          #f) ; not a computed field

(define hasBoughtHouse undefined)
(gui-add! Box1HouseOwning
          boolean-widget
          "Did you buy a house in 2010?"
          (lambda () #t)
          (lambda (v) (set! hasBoughtHouse v))
          #f)

(define hasMaintLoan undefined)
(gui-add! Box1HouseOwning
          boolean-widget
          "Did you buy a house in 2010?"
          (lambda () #t) ; guard
          (lambda (v) (set! hasMaintLoan v))
          #f)

(define sellingPrice undefined)
(gui-add! Box1HouseOwning
          money-widget
          "Price the house was sold for:"
          (lambda () (?/coerce hasSoldHouse)) ; guard
          (lambda (v) (set! sellingPrice v))
          #f)

(define privateDebt undefined)
(gui-add! Box1HouseOwning
          money-widget
          "Private debts for the sold house:"
          (lambda () (?/coerce hasSoldHouse))
          (lambda (v) (set! privateDebt v))
          #f)

(define valueResidue undefined)
(gui-add! Box1HouseOwning
          money-widget
          "Value residue:"
          (lambda () (?/coerce hasSoldHouse))
          (lambda (v) (set! valueResidue v))
          (lambda () (-/coerce sellingPrice privateDebt)))

(send Box1HouseOwning start)
