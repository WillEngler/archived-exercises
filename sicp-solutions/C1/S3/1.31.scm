(define (product term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* result (term a)))))
  (iter a 1))

;Example: factorial

(define (inc x) (+ x 1))
(define (identity x) x)

(define (factorial n) 
  (product identity 1 inc n))

;Example: pi

(define (even-floor x)
  (if (even? x)
      x
      (- x 1)))

(define (odd-floor x)
  (if (odd? x)
      x
      (- x 1)))

(define (pi accuracy) 
  (* 4.0 
     (/ 
      (product even-floor 3 inc accuracy)
      (product odd-floor 3 inc accuracy))))
