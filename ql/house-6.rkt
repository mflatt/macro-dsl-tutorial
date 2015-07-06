#lang s-exp "form-6.rkt"

(form Box1HouseOwning ; <-- adding quotes should provoke a clear error
      ;; extra parens around first or second part of the next clause
      ;; should give a good error, too:
      [hasSoldHouse "Did you sell a house in 2010?" boolean]
      (when hasSoldHouse
        [sellingPrice "Price the house was sold for:" money]
        [privateDebt "Private debts for the sold house:" money]
        [valueResidue "Value residue:" money (- sellingPrice privateDebt)]))
