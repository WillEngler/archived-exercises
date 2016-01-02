; Write a procedure that computes elements of Pascal’s triangle by means of a recursive process.

;Get the pascal number at row and index
; By getting the sum of the Pascal numbers at row - 1
; and indices index and index -1
(define (pascal-number row index)
  (if (or (= index 0) (= index row )) 1
      (+ (pascal-number (- row 1) (- index 1)) (pascal-number (- row 1) index))))
