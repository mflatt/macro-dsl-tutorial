#lang racket
(require parser-tools/lex
         "parser.rkt")

;; Environment support for token coloring

(provide color-lexer)

(define (color-lexer in offset mode)
  ;; Get next token:
  (define tok (lex in))
  ;; Package classification with srcloc:
  (define (ret mode paren [eof? #f])
    (values (if eof?
                eof
                (token->string (position-token-token tok)
                               (token-value (position-token-token tok))))
            mode 
            paren
            (position-offset (position-token-start-pos tok))
            (position-offset (position-token-end-pos tok))
            0 
            #f))
  ;; Convert token to classification:
  (case (token-name (position-token-token tok))
    [(EOF) (ret 'eof #f #t)]
    [(BOPEN) (ret 'parenthesis '|{|)]
    [(BCLOSE) (ret 'parenthesis '|}|)]
    [(OPEN) (ret 'parenthesis '|(|)]
    [(CLOSE) (ret 'parenthesis '|)|)]
    [(NUM) (ret 'constant #f)]
    [(STRING) (ret 'constant #f)]
    [(ID) (ret 'symbol #f)]
    [(WHITESPACE) (ret 'white-space #f)]
    [(ERROR) (ret 'error #f)]
    [else (ret 'other #f)]))

