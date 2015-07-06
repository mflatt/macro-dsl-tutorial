#lang racket
(require "gui.rkt"
         "ops.rkt")

;(form Box1HouseOwning
;      [hasSoldHouse "Did you sell a house in 2010?" boolean-widget]
;      [sellingPrice "Price the house was sold for:" money-widget]
;      [privateDebt "Private debts for the sold house:" money-widget]
;      [valueResidue "Value residue:" money-widget (-/coerce sellingPrice privateDebt)])

(define Box1HouseOwning
  (make-gui 'Box1HouseOwning))

(define hasSoldHouse undefined)
(gui-add! Box1HouseOwning
          boolean-widget
          "Did you sell a house in 2010?"
          (lambda () #t) ; guard
          (lambda (v) (set! hasSoldHouse v))
          #f) ; not a computed field

(define sellingPrice undefined)
(gui-add! Box1HouseOwning
          money-widget
          "Price the house was sold for:"
          (lambda () #t)
          (lambda (v) (set! sellingPrice v))
          #f)

(define privateDebt undefined)
(gui-add! Box1HouseOwning
          money-widget
          "Private debts for the sold house:"
          (lambda () #t)
          (lambda (v) (set! privateDebt v))
          #f)

(define valueResidue undefined)
(gui-add! Box1HouseOwning
          money-widget
          "Value residue:"
          (lambda () #t)
          (lambda (v) (set! valueResidue v))
          (lambda () (-/coerce sellingPrice privateDebt)))

(send Box1HouseOwning start)
