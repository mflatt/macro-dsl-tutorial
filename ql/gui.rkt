#lang racket/gui

(provide make-gui
         gui-add!
         boolean-widget
         money-widget
         text-widget)

;; A GUI is represented by a `survey-frame%` object

(define (make-gui name)
  (new survey-frame%
       [label (format "~s" name)]))

(define survey-frame%
  (class frame%
    (inherit show)
    
    (define questions null)    
    (define/public (add-question! q)
      (set! questions (cons q questions)))
    
    (define/public (react-all)
      (for ([c (reverse questions)])
        (send c react)))
    
    (define/public (start)
      (react-all)
      (show #t)
      (yield (current-eventspace)))
    
    (super-new)))

;; ----------------------------------------

;; An individual question is housed in a `question-panel%`

(define (gui-add! frame widget question show? update! get-value)
  (define panel (new question-panel%
                     [parent frame]
                     [stretchable-height #f]
                     [show? show?]))
  (new message%
       [parent panel]
       [label question])  
  (void (widget panel update! get-value)))

(define question-panel%
  (class horizontal-panel%
    (inherit get-children)
    (init-field parent)
    (init-field show?)
    (send parent add-question! this)
    (define shown? #t)
    (define/public (react)
      (define s? (show?))
      (unless (equal? s? shown?)
        (if s?
            (send parent add-child this)
            (send parent delete-child this))
        (set! shown? s?))
      (send (last (get-children)) react))
    (define/public (react-all)
      (send parent react-all))
    (super-new [parent parent])))

;; ----------------------------------------

;; Different datatypes corresponds to widgets that are used
;; within question-panel:

(define (boolean-widget panel update! get-value)
  (new (class check-box%
         (define/public (react)
           (when get-value
             (send this set-value (get-value))))
         (super-new))
       [parent panel]
       [label ""]
       [callback (lambda (c e)
                   (update! (send c get-value))
                   (send panel react-all))]))

(define (money-widget panel update! get-value)
  (new (class text-field%
         (define/public (react)
           (when get-value
             (define n (get-value))
             (send this set-value (if (number? n) (~a n) ""))))
         (super-new))
       [parent panel]
       [label #f]
       [callback (lambda (t e)
                   (update! (string->number (send t get-value)))
                   (send panel react-all))]))

(define (text-widget panel update! get-value)
  (new (class text-field%
         (define/public (react)
           (when get-value
             (define n (get-value))
             (send this set-value (if (string? n) n ""))))
         (super-new))
       [parent panel]
       [label #f]
       [callback (lambda (t e)
                   (update! (send t get-value))
                   (send panel react-all))]))
