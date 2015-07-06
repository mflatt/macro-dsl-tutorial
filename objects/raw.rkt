#lang racket/base

(provide class
         make-object
         get-field
         set-field!
         lookup-method)

(struct class (methods  ; (hashof symbol (object any ... -> any))
               field-positions)) ; (hashof symbol integer)

(struct object (class   ; class
                [fields #:mutable])) ; (listof any)

(define (make-object c . args)
  (object c (list->vector args)))

(define (get-field o name)
  (vector-ref (object-fields o)
              (hash-ref (class-field-positions (object-class o)) name)))

(define (set-field! o name v)
  (vector-set! (object-fields o)
               (hash-ref (class-field-positions (object-class o)) name)
               v))

(define (lookup-method o name)
  (hash-ref (class-methods (object-class o)) name))
