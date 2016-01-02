(define (+ a b)
  (if (= a 0)
      b
      (inc (+ (dec a) b))))

;(+ 4 5)
;(inc (+ 3 5))
;(inc (inc (+ 2 5)))
;(inc (inc (inc (+ 1 5))))
;(inc (inc (inc (inc (+ 0 5)))))
;(inc (inc (inc (inc 5))))
;...
;9
;
; We see that it is a recursive process because of the delayed evaluation.



(define (+ a b)
  (if (= a 0)
      b
      (+ (dec a) (inc b))))

;(+ 4 5)
;(+ 3 6)
;(+ 2 7)
;(+ 1 8)
;(+ 0 9)
;9
;
; It is a linear process because it performs the computation with a fixed number of state variables.
