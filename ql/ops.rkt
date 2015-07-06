#lang racket

(provide undefined
         ?/coerce
         -/coerce
         </coerce >/coerce =/coerce
         and/coerce or/coerce
         provide-ops)

;; ----------------------------------------

(define undefined 'undefined)

(define (?/coerce v)
  (cond
    [(eq? undefined v) #f]
    [else (and v #t)]))

(define (-/coerce a b)
  (- (if (number? a) a 0)
     (if (number? b) b 0)))

(define-syntax-rule (define-comp-coerce x/coerce x)
  (define (x/coerce a b)
    (and (number? a) 
         (number? b)
         (x a b))))
(define-comp-coerce </coerce <)
(define-comp-coerce >/coerce >)
(define-comp-coerce =/coerce =)

(define (and/coerce a b) (and (?/coerce a) (?/coerce b)))
(define (or/coerce a b) (or (?/coerce a) (?/coerce b)))

;; ----------------------------------------

(define-syntax-rule (provide-ops)
  (provide (rename-out [-/coerce -]
                       [>/coerce >]
                       [</coerce <]
                       [=/coerce =]
                       [and/coerce and]
                       [or/coerce or])))
