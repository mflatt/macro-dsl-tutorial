#lang racket/base
(require "class.rkt"
         racket/math)

(define point-class
  (class [x y] ; fields
    this ; name that refers back to self
    (define (get-x) x)
    (define (get-y) y)
    (define (set-x v) (set! x v))
    (define (set-y v) (set! y v))
    (define (rotate degrees)
      (define pt (make-rectangular x y))
      (define new-pt (make-polar
                      (magnitude pt)
                      (+ (angle pt) (* pi (/ degrees 180)))))
      (set! x (real-part new-pt))
      (set! y (imag-part new-pt)))))

(define a-pt (make-object point-class 0 5))

(send a-pt set-x 10)
(send a-pt rotate 90)
(send a-pt get-x)
(send a-pt get-y)


