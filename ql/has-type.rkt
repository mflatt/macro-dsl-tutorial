#lang racket
(require (for-syntax syntax/parse))

(provide define-typed
         has-type
         check-type)

(begin-for-syntax
  (define (typed id type)
    (lambda (stx)
      (if (identifier? stx)
          #`(has-type #,id #,type)
          (raise-syntax-error
           #f
           "cannot use variable as a function"
           stx)))))

(define-syntax define-typed
  (lambda (stx)
    (syntax-parse stx
      [(define-typed id val-id type)
       (unless (identifier? #'id)
         (raise-syntax-error #f
                             "expected an identifier"
                             #'id))
       (unless (identifier? #'val-id)
         (raise-syntax-error #f
                             "expected an identifier that holds the value"
                             #'val-id))
       #'(define-syntax id (typed #'val-id #'type))])))

(define-syntax-rule (has-type expr type)
  expr)

(define-syntax check-type
  (lambda (stx)
    (syntax-parse stx
      [(_ expr expected-type)
       (let ([expr2 (local-expand #'expr
                                  'expression
                                  (list #'has-type))])
         (syntax-parse expr2 #:literals (has-type)
           [(has-type v type)
            (unless (equal? (syntax-e #'type)
                            (syntax-e #'expected-type))
              (raise-syntax-error
               'form
               (format "expected type ~a, found type ~a"
                       (syntax-e #'expected-type)
                       (syntax-e #'type))
               #'expr))
            expr2]
           [_
            (raise-syntax-error
             'form
             (format "expected type ~a, found expression of unknown type"
                     (syntax-e #'expected-type))
             #'expr)]))])))
