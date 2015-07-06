#lang racket
(require "parser.rkt")

(provide read-syntax
         read)

;; To read a module:
(define (read-syntax src-name in)
  (define stx (parse src-name in))
  (let* ([p-name (object-name in)]
         [name (if (path? p-name)
                   (let-values ([(base name dir?) (split-path p-name)])
                     (string->symbol
                      (path->string (path-replace-suffix name #""))))
                   'anonymous)])
    (datum->syntax #f `(module ,name "form-t2.rkt" (#%module-begin ,stx)))))

;; In case `read' is used, instead of `read-syntax':
(define (read in)
  (syntax->datum (read-syntax (object-name in) in)))
