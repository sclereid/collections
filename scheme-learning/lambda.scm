;;; lambda.scm : perform lambda-calculus within scheme

(define (atom x)
  (and (not (pair? x))
       (not (null? x))))

(define (compose f g . s)
  (if (null? s)
      (lambda (x) (f (g x)))
      (lambda (x)
        (f ((apply compose (cons g s)) x)))))

(define (take n ls)
  (if (= n 0)
      '()
      (cons (car ls)
            (take (- n 1) (cdr ls)))))

(define (distinguishable-name names)
  (let ((chars (map (compose string->list
                             symbol->string)
                    names)))
    ((compose string->symbol list->string)
     (let loop ((cs chars) (ans '(#\a)))
       (if (null? cs)
           ans
           (loop (cdr cs)
                 (let ((m (length (car cs)))
                       (n (length ans)))
                   (cond
                     ((< m n) (loop (cdr cs) ans))
                     ((= m n)
                      (if (equal? (car cs) ans)
                          (append ans (list #\1))
                          ans))
                     (else
                      (if (equal? (take n (car cs)) ans)
                          (append ans
                                  (list (different-char (list-ref n (car cs)))))
                          ans))))))))))

(define (different-char x)
  (let ((ci char->integer)
        (ic integer->char))
    (cond
      ((<= (ci #\0) (ci x) (ci #\8))
       (ic (+ (ci x) 1)))
      ((= (ci #\9) (ci x))
       #\0)
      ((<= (ci #\a) (ci x) (ci #\y))
       (ic (+ (ci x) 1)))
      ((= (ci #\z) (ci x))
       #\a)
      ((<= (ci #\A) (ci x) (ci #\Y))
       (ic (+ (ci x) 1)))
      ((= (ci #\Z) (ci x))
       #\A)
      (else #\0))))

(display (distinguishable-name '(a a1 ccc)))

#|
(define (substitute from-expr to-expr in-expr)
  (cond
    ((eqv? to-expr in-expr) from-expr)
    ((atom? to-expr in-expr) in-expr)
    ((application? in-expr)
     (make-application (substitute from-expr
                                   to-expr
                                   (application-operator in-expr))
                       (substitute from-expr
                                   to-expr
                                   (application-operand in-expr))))
    ((lambda-form? in-expr)
     (let ((psi (lambda-label in-expr))
           (p (lambda-content in-expr)))
       (if (
|#
