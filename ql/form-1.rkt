#lang racket
(require "gui.rkt"
         "ops.rkt")

;; >>> define `form` <<<

; ----------------------------------------

(form Box1HouseOwning
      [hasSoldHouse "Did you sell a house in 2010?" boolean-widget]
      [sellingPrice "Price the house was sold for:" money-widget])
