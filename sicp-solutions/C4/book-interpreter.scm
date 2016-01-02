; PART 1: Eval, Apply, and their friends.

; The granddaddy: Given an expression and an environment, evaluate the expression.
(define (eval exp env)
; Find out what kind of expression we're dealing with, 
; then call the right operation on the expression to break it down into
; something that is self-evaluating.
  (cond ((self-evaluating? exp) 
         exp)
        ((variable? exp) 
         (lookup-variable-value exp env))
        ((quoted? exp) 
         (text-of-quotation exp))
        ((assignment? exp) 
         (eval-assignment exp env))
        ((definition? exp) 
         (eval-definition exp env))
        ((if? exp) 
         (eval-if exp env))
        ((lambda? exp)
         (make-procedure 
          (lambda-parameters exp)
          (lambda-body exp)
          env))
        ((begin? exp)
         (eval-sequence 
          (begin-actions exp) 
          env))
        ((cond? exp) 
         (eval (cond->if exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values 
                 (operands exp) 
                 env)))
        (else
         (error "Unknown expression 
                 type: EVAL" exp))))

; Must be defined before we create a new definition for apply.
(define apply-in-underlying-scheme apply)

; Applies an operation to a list of arguments
(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure 
          procedure 
          arguments))
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
; Compound procedures need their own frame to bind arguments
          (extend-environment
           (procedure-parameters 
            procedure)
           arguments
           (procedure-environment 
            procedure))))
        (else
         (error "Unknown procedure 
                 type: APPLY" 
                procedure))))

; Used in eval to make arguments into a list for apply to operate on
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values 
             (rest-operands exps) 
             env))))

; Handles the 'if' special form.
; Only evaluates one branch based on the predicate.
; (That it is defined with the underlying Scheme's 'if' blows my mind a bit.)
(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

; Ensures that expressions are evaluated in the correct order.
; Use cases: A 'begin' expression and a procedure body.
(define (eval-sequence exps env)
  (cond ((last-exp? exps) 
         (eval (first-exp exps) env))
        (else 
         (eval (first-exp exps) env)
         (eval-sequence (rest-exps exps) 
                        env))))

; Handles assignments by looking up a variable and setting its value
; to the value the assignment expression evaluates to.
(define (eval-assignment exp env)
  (set-variable-value! 
   (assignment-variable exp)
   (eval (assignment-value exp) env)
   env)
  'ok)

; Creates the variable-value binding in the environment.
(define (eval-definition exp env)
  (define-variable! 
    (definition-variable exp)
    (eval (definition-value exp) env)
    env)
  'ok)

; PART 2: How do we represent symbols?

; Only numbers and strings are self-evaluating.
; This is what we have to break down expressions to.
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

; A variable is a symbol.
; (It seems like we're putting off the question of what a variable is...)
(define (variable? exp) (symbol? exp))

;A quotation is a list beginning with 'quote
(define (quoted? exp)
  (tagged-list? exp 'quote))

; ... so the text is everything but the preceding 'quote.
(define (text-of-quotation exp)
  (cadr exp))

; A helper to identify lists tagged with a given quote.
(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

; Assignment starts with 'set! ...
(define (assignment? exp)
  (tagged-list? exp 'set!))

; We're assigning to the second thing in the list ...
(define (assignment-variable exp) 
  (cadr exp))

; ... and the value is the third thing.
(define (assignment-value exp) (caddr exp))

; Definitions always start with 'define
(define (definition? exp)
  (tagged-list? exp 'define))

; What is the variable we're defining?
(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp) ; If it's not a procedure, then it's just the second value.
      (caadr exp))) ; If it is a procedure, 
                    ; then it's the first member of the second value (which is a list)

; Get the value we're assigning.
(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp) ; If it's not a procedure definition,
                  ; Then we're using the value that's the third element of the list.
      (make-lambda ; If it is a preocedure definition, transform the body
                   ; to a lambda that we can assign to the variable.
       (cdadr exp)   ; formal parameters
       (cddr exp)))) ; body


; Lambdas have a telltale 'lambda tag. 
(define (lambda? exp) 
  (tagged-list? exp 'lambda))

; The parameter list is the second element in the list.
(define (lambda-parameters exp) (cadr exp))

; And the body is the third element in the list.
(define (lambda-body exp) (cddr exp))

; We'll use a lambda constructor to de-sugar named procedure definitions.
(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

; if statements are tagged with 'if
(define (if? exp) (tagged-list? exp 'if))

; The predicate is the second element in the list.
(define (if-predicate exp) (cadr exp))

; The consequent is the third.
(define (if-consequent exp) (caddr exp))

; The alternative is the fourth.
; If it is not defined, we provide a default value of 'false
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

; For desugaring cond expressions.
(define (make-if predicate 
                 consequent 
                 alternative)
  (list 'if 
        predicate 
        consequent 
        alternative))

; begin expressions start with 'begin
(define (begin? exp) 
  (tagged-list? exp 'begin))

; Just renaming operations to make it easier to read code
; that operates on begin expressions.
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))


; Helper to turn a sequence into an expression
(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

; Tags a sequence with 'begin to make it a begin expression
(define (make-begin seq) (cons 'begin seq))

; If it's not a special form, it's a compund expression.
; I don't really understand the definition of application? though.
; Maybe it works because it's only used after exhausting all options for special forms.
; Seems like a misleading name.
(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

; Converts cond expressions to a big 'ol nested if statement
(define (cond? exp) 
  (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) 
  (car clause))
(define (cond-actions clause) 
  (cdr clause))
(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))
(define (expand-clauses clauses)
  (if (null? clauses)
      'false     ; no else clause
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp 
                 (cond-actions first))
                (error "ELSE clause isn't 
                        last: COND->IF"
                       clauses))
            (make-if (cond-predicate first)
                     (sequence->exp 
                      (cond-actions first))
                     (expand-clauses 
                      rest))))))

; PART 3: Evaluator Data Structures

; We need the true? and false? predicates to separate our interpreter's notion of truth
; from the language we're operating on. It just so happens that we're still operating on Scheme.

; Anything that isn't the 'false symbol is true
(define (true? x)
  (not (eq? x false)))

; Only the 'false symbol is false.
(define (false? x)
  (eq? x false))

; In keeping with the environment model of evaluation,
; the interpreter needs to represent procedures as the parameters and the body,
; (the things the programmer implicitly defined)
; as well as the environment the procedure is evaluated in.

; Tag the procedure definition with 'procedure.
(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

; Check if p has the 'procedure tag.
(define (compound-procedure? p)
  (tagged-list? p 'procedure))

; The second list element is the parameters.
(define (procedure-parameters p) (cadr p))

; The third is the body.
(define (procedure-body p) (caddr p))

; The fourth is the environment.
(define (procedure-environment p) (cadddr p))

; The interpreter must also represent environments somehow.
; It will do so by storing environments as a list of frames: innermost first, outermost last.

; The "enclosing environment" is everything outside of the first frame
; (The first frame is probably the frame created by a procedure)
(define (enclosing-environment env) (cdr env))

; The first frame is, well, the first frame in the list of frames that is the environment.
(define (first-frame env) (car env))

; If environments are lists, then the empty environment should be the empty list.
; (Scheme's use of '() reminds me of Rust's use of ().)
(define the-empty-environment '())

; Now we need code to construct frames.

; A frame has a list of variables and a list of values.
; The nth variable maps to the nth value.
(define (make-frame variables values)
  (cons variables values))

; Getter for the variables.
(define (frame-variables frame) (car frame))

; Getter for the values.
(define (frame-values frame) (cdr frame))

; Append new variable bindings to the front of the frame.
(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

; Check that the lengths of a frame's vars and vals match
; before appending the new frame to a base-env.
(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" 
                 vars 
                 vals)
          (error "Too few arguments supplied" 
                 vars 
                 vals))))

; Loop through each frame from first to last
; until you find the variable.
; If you don't find it, the variable is unbound.
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop 
              (enclosing-environment env)))
            ((eq? var (car vars))
             (car vals))
            (else (scan (cdr vars) 
                        (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

; Much like lookup-variable-value.
; When you find the variable, update its value.
(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop 
              (enclosing-environment env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) 
                        (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable: SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

; To define a variable,
; first see if it already exists so that we can properly shadow it.
; Else, add it to the first frame.
(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! 
              var val frame))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) 
                        (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))

; STEP 4: Running The Evaluator

; We've put off how we are going to apply primitive procedures.

; We'll need to bootstrap the first environment with primitive procedure bindings.
(define (setup-environment)
  (let ((initial-env
         (extend-environment 
          (primitive-procedure-names)
          (primitive-procedure-objects)
          the-empty-environment)))
; Also, we need to throw in truth and falsehood.
; Our true? and false? predicates rely on these symbols.
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))

; We'll just defer primitive procedure calls to the underlying Scheme.

; A primitive procedure is tagged with 'primitive.
(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

; The implementation comes after the tag.
(define (primitive-implementation proc) 
  (cadr proc))

; Just define the primitives as their underlying Scheme equivalents.
(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list '+ +)
        (list '- -)
        (list '* *)
        (list '/ /)
        (list '> >)
        (list '< <)
        (list '>= >=)
        (list '<= <=)))

; Grab all of the primitive procedure names.
(define (primitive-procedure-names)
  (map car primitive-procedures))

; Take each primitive procedure's implementation and tag it with 'primitive.
(define (primitive-procedure-objects)
  (map (lambda (proc) 
         (list 'primitive (cadr proc)))
       primitive-procedures))

; Use the underlying Scheme's apply to apply a primitive procedure to the arguments.
(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

; This is what our REPL will print.
(define input-prompt  ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")

; REPL driver.
(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output 
           (eval input 
                 the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))
(define (prompt-for-input string)
  (newline) (newline) 
  (display string) (newline))
(define (announce-output string)
  (newline) (display string) (newline))

; Helper to print useful results without the whole environment tagging along.
(define (user-print object)
  (if (compound-procedure? object)
      (display 
       (list 'compound-procedure
             (procedure-parameters object)
             (procedure-body object)
             '<procedure-env>))
      (display object)))

; I didn't like this.
; Then I stared it for a minute and I loved it.
(define the-global-environment 
  (setup-environment))

