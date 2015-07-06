#lang racket

(module reader racket/base
  (require parser-tools/lex
           "reader.rkt"
           "color-lexer.rkt")

  (provide read-syntax
           read
           get-info)

  ;; To get info about the language's environment support:
  (define (get-info in mod line col pos)
    (lambda (key default)
      (case key
        [(color-lexer) color-lexer]
        [else default]))))
