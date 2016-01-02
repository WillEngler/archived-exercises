(define (accummulate combiner null-value term a next b)
  (define (iter a result )
    (if (> a b)
        result
        (iter (next a) (combiner result (term a)))))
  (iter a null-value))

(define (sum term a next b)
  (accumulate + 0 term a next b))

(define (product term a next b)
  (accumulate * 1 term a next b))

(define (filtered-accumulate predicate? combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (if (predicate? a)
            (iter (next a) (combiner result (term a)))
            (iter (next a) result))))
  (iter a null-value))

(define (inc x) (+ x 1))
(define (identity x) x)

(define (sum-of-evens start stop) 
  (filtered-accumulate even? + 0 identity start inc stop))
