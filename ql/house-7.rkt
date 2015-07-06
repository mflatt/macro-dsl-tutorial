#lang s-exp "form-7.rkt"

(form Box1HouseOwning
      [hasSoldHouse "Did you sell a house in 2010?" boolean]
      (when hasSoldHouse
        [sellingPrice "Price the house was sold for:" money]
        [privateDebt "Private debts for the sold house:" money]
        [valueResidue "Value residue:" money
                      ;; Using `when` here should not work:
                      (- sellingPrice privateDebt)]))
