(define (p) (p))

(define (test x y) 
  (if (= x 0) 
      0 
      y))

(test 0 (p))

; Clever, Ben.
; If the interpreter is using applicative order, it will enter an infinite loop.
; Applicative order evaluates the operands before applying the operator, so it tries to evaluate p.
; Because p is defined as p, the interpreter keeps applying the definition infinitely.

; But, if the interpreter is using normal order, it will promptly evaluate to 0.
; It will test x and 0 for equality,
; and then evaluate to 0 without ever reaching the formal parameter y,
; which will have been substituted with p.

