#lang racket
(require "gui.rkt"
         "ops.rkt")

;(form Box1HouseOwning
;      [hasSoldHouse "Did you sell a house in 2010?" boolean-widget]
;      [sellingPrice "Price the house was sold for:" money-widget])

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
          (lambda () #t) ; guard
          (lambda (v) (set! sellingPrice v))
          #f) ; not a computed field

(send Box1HouseOwning start)
