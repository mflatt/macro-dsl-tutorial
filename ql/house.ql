#lang reader "reader.rkt"

form Box1HouseOwning {
   hasSoldHouse: "Did you sell a house in 2010?" boolean
   hasBoughtHouse: "Did you by a house in 2010?" boolean
   hasMaintLoan: "Did you enter a loan for maintenance/reconstruction?" boolean
 
   if (hasSoldHouse) {
     sellingPrice: "Price the house was sold for:" money
     privateDebt: "Private debts for the sold house:" money
     valueResidue: "Value residue:" money(sellingPrice - privateDebt)
   }
}
