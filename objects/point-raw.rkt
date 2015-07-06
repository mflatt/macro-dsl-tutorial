#lang racket/base
(require "raw.rkt"
         racket/math)

(define point-class
  (class
    (hash 'get-x
          (lambda (this) (get-field this 'x))
          'get-y
          (lambda (this) (get-field this 'y))
          'set-x
          (lambda (this v) (set-field! this 'x v))
          'set-y
          (lambda (this v) (set-field! this 'y v))
          'rotate
          (lambda (this degrees)
            (define pt (make-rectangular
                        (get-field this 'x)
                        (get-field this 'y)))
            (define new-pt (make-polar
                            (magnitude pt)
                            (+ (angle pt) (* pi (/ degrees 180)))))
            (set-field! this 'x (real-part new-pt))
            (set-field! this 'y (imag-part new-pt))))
    (hash 'x 0
          'y 1)))

(define a-pt (make-object point-class 0 5))

((lookup-method a-pt 'set-x) a-pt 10)
((lookup-method a-pt 'rotate) a-pt 90)
((lookup-method a-pt 'get-x) a-pt)
((lookup-method a-pt 'get-y) a-pt)

