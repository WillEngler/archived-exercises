; First, examine the numerical integration procedure given in the book

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (cube x) (* x x x))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b) 
     dx))

; Now let's implement Simpson's rule

(define (inc x) (+ x 1))

(define (simpson n f a b) 
  (
   (let ((h (/ (- b a) n)))
     (define (simpson-term k) 
       (let ((y (f (+ a (* k h)))))
         (if (or (= k 0) (= k n))
             y
             (if (even? k) 
                 (* 2 y)
                 (* 4 y)))))
     (* (/ h 3) 
        (sum simpson-term a inc b))
     )))

; Take 2

(define (curry-simpson a h n f)
  (lambda (k)
    (simpson-term a h k n f)))

(define (simpson-term a h k n f)
; Compute y sub k
  (let ((y (f (+ a (* k h)))))
;Special cases for first and final term
    (cond ((or (= k 0) (= k n)) y)
          ((even? k) (* 2 y))
          ((odd? k) (* 4 y)))))

(define (simpson f a b n) 
  (let ((h (/ (- b a) n)))
    (* 
     (/ h 3)
     (sum (curry-simpson a h n f) a inc n))))


