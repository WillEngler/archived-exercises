;Define a procedure that takes three numbers as arguments 
;and returns the sum of the squares of the two larger numbers.

(define (square x) (* x x))

; Sheesh.
(define (<= x y) 
  (or (< x y) (= x y)))

; Is candidate no greater than x and y?
(define (smallest? candidate x y) 
  (and (<= candidate  x) (<= candidate y))
)

(define (sum-of-squares x y) (+ (square x) (square y)))

(define (sum-of-squares-of-two-largest x y z)  
  (cond ((smallest? x y z) (sum-of-squares y z))
        ((smallest? y x z) (sum-of-squares x z))
        ((smallest? z x y) (sum-of-squares x y))
        )
)
