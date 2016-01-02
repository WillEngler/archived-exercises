(define (improve guess x)
  (/ (+ 
      (/ x (square guess)) 
      (* 2 guess))
     3))

(define (average x y) 
  (/ (+ x y) 2))

(define (crt x)
  (crt-iter 0.0 1.0 x))

; Yay! Using my solution to 1.7, I don't have to change my good-enough? check.
(define (good-enough? prev-guess curr-guess x)
  (< (/ (abs (- curr-guess prev-guess)) curr-guess) 0.001))


(define (crt-iter prev-guess curr-guess x)
  (if (good-enough? prev-guess curr-guess x)
      curr-guess
      (crt-iter curr-guess (improve curr-guess x) x)))
