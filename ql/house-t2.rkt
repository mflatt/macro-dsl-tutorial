#lang s-exp "form-t2.rkt"

(form Box1HouseOwning
      [hasSoldHouse "Did you sell a house in 2010?" boolean]
      (when hasSoldHouse ; <- using `sellingPrice` here should be a type error
        [sellingPrice "Price the house was sold for:" money]
        [privateDebt "Private debts for the sold house:" money]
        [valueResidue "Value residue:" money
                      ;; `hasSoldHouse` here should be a type error:
                      (- sellingPrice privateDebt)]))
