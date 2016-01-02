; Now suppose we include, together with addition, operations double, which doubles an integer, and halve, which divides an (even) integer by 2. Using these, design a multiplication procedure analogous to fast-expt that uses a logarithmic number of steps.

(define (double n) (+ n n))
(define (halve n) (/ n 2))

(define (fast-mult a b) (fast-mult-iter 0 a b))

(define (fast-mult-iter running-sum a b) 
  (cond ((= b 1) (+ running-sum a))
        ((even? b) (fast-mult-iter running-sum (double a) (halve b)))
        (else
         (fast-mult-iter (+ running-sum a) a (- b 1)))))
