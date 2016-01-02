; Why is the original implementation bad for small numbers?
; Small value: (sqrt .0001) = .03208... 
; It is computing if the difference between the guess squared and x is smaller than .001.
; If we are finding the root of .0001 
; then we probably want precision to the 4th decimal place.

; Why is it bad for large numbers?
; (sqrt 10000009876543212345678987654323456789876543456787654345678) = 1.0000004938270387e29
; Floating point arithmetic loses precision.

; Here's my alternate implementation

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y) 
  (/ (+ x y) 2))

(define (sqrt x)
  (sqrt-iter 0.0 1.0 x))

(define (good-enough? prev-guess curr-guess x)
  (< (/ (abs (- curr-guess prev-guess)) curr-guess) 0.001))


(define (sqrt-iter prev-guess curr-guess x)
  (if (good-enough? prev-guess curr-guess x)
      curr-guess
      (sqrt-iter curr-guess (improve curr-guess x) x)))

; Score!
; This new version does a lot better for small numbers
; (sqrt .0001) = ;Value: 1.0000000025490743e-2

; What about big numbers?
; It performs the same.
; THe adjustment to good-enough? didn't work any magic on floating point arithmetic.

