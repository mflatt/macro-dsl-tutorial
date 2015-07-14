#lang racket/base
(require (rename-in "with-method.rkt"
                    [class raw:class]))

(provide class
         make-object
         send
         with-method)

;; >>> define `class` <<<
;;  where the expansion uses `raw:class`
