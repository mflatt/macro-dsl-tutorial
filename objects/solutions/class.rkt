#lang racket/base
(require (rename-in "with-method.rkt"
                    [class runtime:class]))

(provide class
         make-object
         send
         with-method)

(define-syntax class 
  (syntax-rules (define)
    [(_ [field-name ...]
        this-id
        (define (method-name arg ...) body ...)
        ...)
     (runtime:class
      (for/hash ([name '(method-name ...)]
                 [proc (list (lambda (this-id arg ...)
                               (define-field field-name this-id)
                               ...
                               body ...)
                             ...)])
        (values name proc))
      (for/hash ([name '(field-name ...)]
                 [pos (in-naturals)])
        (values name pos)))]))

(define-syntax-rule (define-field field-name this-id)
  (define-syntax field-name
    (syntax-id-rules (set!)
     [(set! id v)
      (set-field! this-id 'field-name v)]
     [(id arg (... ...))
      ((get-field this-id 'field-name) arg (... ...))]
     [id
      (get-field this-id 'field-name)])))
