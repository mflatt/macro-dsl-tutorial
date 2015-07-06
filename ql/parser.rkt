#lang racket/base
(require parser-tools/lex 
         (prefix-in : parser-tools/lex-sre)
         algol60/cfg-parser
         syntax/readerr
         (for-syntax racket/base))

(provide lex
         parse
         token->string)

(define (parse src-name in)
  (parameterize ([current-source src-name])
    (parse-from-lex (lambda () 
                      ;; Discard whitespace from `lex`:
                      (let loop ()
                        (let ([v (lex in)])
                          (if (eq? 'WHITESPACE (position-token-token v))
                              (loop)
                              v)))))))

;; ----------------------------------------
;; Lexer

(define-tokens content-tokens
  (ID NUM BINOP STRING ERROR))

(define-empty-tokens delim-tokens
  (EOF FORM OPEN CLOSE BOPEN BCLOSE
       MINUS LESS GREATER EQUAL COLON
       AND OR IF
       BOOLEAN MONEY
       WHITESPACE))

(define lex
  (lexer-src-pos
   [(:or (:seq (:+ (:/ "0" "9")) (:? ".") (:* (:/ "0" "9")))
         (:seq "." (:* (:/ "0" "9"))))
    (token-NUM (string->number lexeme))]
   [(:seq #\" (:* (:~ #\")) #\") 
    (token-STRING (substring lexeme 1 (sub1 (string-length lexeme))))]
   ["{" 'BOPEN]
   ["}" 'BCLOSE]
   ["(" 'OPEN]
   [")" 'CLOSE]
   ["-" 'MINUS]
   ["<" 'LESS]
   [">" 'GREATER]
   ["=" 'EQUAL]
   [":" 'COLON]
   ["&&" 'AND]
   ["||" 'OR]
   ["if" 'IF]
   ["form" 'FORM]
   ["boolean" 'BOOLEAN]
   ["money" 'MONEY]
   [(:seq (:/ #\A #\Z #\a #\z)
          (:+ (:/ #\A #\Z #\a #\z #\0 #\9)))
    (token-ID (string->symbol lexeme))]
   [(:+ whitespace) 'WHITESPACE]
   [(eof) 'EOF]
   [any-char (token-ERROR lexeme)]))

(define parse-from-lex
  (cfg-parser
   (start <form>)
   (end EOF)
   (tokens content-tokens
           delim-tokens)
   (precs)
   (error (lambda (a t v start end) 
            (raise-parse-error t v start end)))
   (src-pos)
   (grammar
    (<form> [(FORM <id> BOPEN <clauses> BCLOSE)
             (at-src `(form ,$2 ,@$4))])
    (<clauses> [() null]
               [(<clause> <clauses>) (cons $1 $2)])
    (<clause> [(<id> COLON <string> <type>)
               (at-src `[,$1 ,$3 ,$4])]
              [(<id> COLON <string> <type> <expr>)
               (at-src `[,$1 ,$3 ,$4 ,$5])]
              [(IF OPEN <expr> CLOSE BOPEN <clauses> BCLOSE)
               (at-src `(when ,$3 ,@$6))])
    (<string> [(STRING) (at-src $1)])
    (<id> [(ID) (at-src $1)])
    (<expr> [(NUM) (at-src $1)]
            [(<string>) $1]
            [(<id>) $1]
            ;; [(<unop> <expr>) (at-src `(,$1 ,$2))]
            [(<expr> <binop> <expr>) (at-src `(,$2 ,$1 ,$3))]
            [(OPEN <expr> CLOSE) $2])
    (<binop> [(MINUS) (at-src '-)]
             [(LESS) (at-src '<)]
             [(GREATER) (at-src '>)]
             [(EQUAL) (at-src '=)]
             [(AND) (at-src 'and)]
             [(OR) (at-src 'or)])
    ;; (<unop>)
    (<type> [(BOOLEAN) (at-src 'boolean)]
            [(MONEY) (at-src 'money)]))))

(define-syntax (at-src stx)
  (syntax-case stx ()
    [(_ e) 
     (with-syntax ([start (datum->syntax stx '$1-start-pos)]
                   [end (datum->syntax stx '$n-end-pos)])
       #'(datum->syntax #f e (to-srcloc start end) orig-prop))]))

(define orig-prop (read-syntax 'src (open-input-bytes #"x")))

;; ----------------------------------------
;; Source locations and error reporting:

(define current-source (make-parameter #f))

(define (to-srcloc start end)
  (list
   (current-source)
   (position-line start)
   (position-col start)
   (position-offset start)
   (and (position-offset end)
        (position-offset start)
        (- (position-offset end)
           (position-offset start)))))

(define (raise-parse-error t v start end)
  (apply
   (if (eq? t 'EOF) raise-read-eof-error raise-read-error) 
   (format "bad syntax at ~a" (token->string t v))
   (to-srcloc start end)))

(define (token->string t v)
  (if v
      (format "~a" v)
      (format "~a" t)))
