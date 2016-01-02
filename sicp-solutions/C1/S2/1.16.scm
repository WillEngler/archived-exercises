;Design a procedure that evolves an iterative exponentiation process that uses successive squaring and uses a logarithmic number of steps, as does fast-expt.

; Invariant: ab^n is always the same



(define (fast-expt b n)
  (fast-expt-iter 1 b n))

(define (fast-expt-iter a b n)
  (cond ((= n 0) a) 
        ((odd? n) (fast-expt-iter (* b a)  b (- n 1)))
        (else 
         (fast-expt-iter  a (square b) (/ n 2)))))

; This was tricky for me.
; Writing it out helped.
; And keeping the invaiant in mind was invaluable.
