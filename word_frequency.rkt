
#lang racket
(require csc151)
(require plot)


;;; Procedure:
;;;   my-tally
;;; Parameters:
;;;   filename, a string containing a file path
;;; Purpose:
;;;   tallies all the words in a file and sorts them in descending order of frequency
;;; Produces:
;;;;  result, a list of lists  
(define my-tally 
  (lambda (filename)
    (let ([compare-second-element?< 
           (lambda (lst1 lst2)
             (> (cadr lst1)
                (cadr lst2)))])
      (sort (tally-all (sort (file->words filename) string-ci>?)) compare-second-element?<))))

;;; Procedure:
;;;   assoc-ci
;;; Parameters:
;;;   key, a string
;;;   alist, an association list
;;; Purpose:
;;;   Find an entry with a matching key in alist.
;;; Produces:
;;;   entry, a Scheme value
;;; Preconditions:
;;;   The car of each entry in alist is a string
;;; Postconditions:
;;;   * If there is an index, i, such that
;;;     (string-ci=? key (car (list-ref alist i)))
;;;     then entry is the first such entry
;;;   * Otherwise, entry is false (#f)

;;; Citation: http://www.cs.grinnell.edu/~klingeti/courses/f2017/csc151/readings/association-lists

(define assoc-ci 
  (lambda (key alist)
    (cond
      [(null? alist) 
       #f]
      [(string-ci=? key (car (car alist))) 
       (car alist)]
      [else 
       (assoc-ci key (cdr alist))])))

;;; Procedure:
;;;   pair
;;; Parameters:
;;;   str, a string
;;;   weights, a procedure
;;; Purpose:
;;;   converts four weighted frequencies into Cartesian coordinates
;;; Produces:
;;;   coordinates, a list
;;; Preconditions:
;;;   weights is a procedure which weighs frequencies according to previously calculated values 
;;; Postconditions:
;;;   * Number of elements in coordinates is 2 
;;;   * All values in coordinates are real
(define pair 
  (lambda (str weights)
    (list (/ (- (car (weights str)) (cadr (weights str))) 2)
          (/ (- (caddr (weights str)) (cadddr (weights str))) 2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;explain what these are 

(define rep "/home/drallpra/Desktop/proj/republican.csv") ;address to .csv with words spoken by republican candidates
(define female "/home/drallpra/Desktop/proj/female.csv") ;address to .csv with words spoken by female candidates
(define dem "/home/drallpra/Desktop/proj/democrat.csv") ;address to .csv with words spoken by democrat candidates
(define male "/home/drallpra/Desktop/proj/male.csv") ;address to .csv with words spoken by male cradidates


;;; Procedure:
;;;   weights-debates
;;; Parameters:
;;;   str, a string
;;; Purpose:
;;;   weighs frequencies according to previously calculated values based
;;;   on approximate sizes of groups and corresponding debate responses
;;;   In this case, the value is 1 because Republicans and Democrats spoke for
;;;   similar amounts of times (12 hours) and Hilary Clinon and Carly Fiorina
;;;   combined to speak as much as other male candidates based on a cursory analysis of the dataset
;;; Produces:
;;;   weighed, a list of numbers
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   * length of corresponding list is always 4 
;;;   * if str does not have an associated value, the procedure assigns the value 0
;;;   * all values in weighed are real
(define weights-debates 
  (lambda (str)
    (map exact->inexact
         (list
          (/ (cadr (or (assoc-ci str (my-tally rep))
                       (list "dummy-string" 0)))
             1)
          (/ (cadr (or (assoc-ci str (my-tally dem))
                       (list "dummy-string" 0)))
             1) 
          (/ (cadr (or (assoc-ci str (my-tally male))
                       (list "dummy-string" 0)))
             1)
          (/ (cadr (or (assoc-ci str (my-tally female))
                       (list "dummy-string" 0)))
             1)))))

;;; Procedure:
;;;   candidates
;;; Parameters:
;;;   str, a string
;;; Purpose:
;;;   plots a four-way graph which represents the group of candidates that used str more
;;;   frequently in the 2016 Presidential Debates relative to other groups
;;; Produces:
;;;   graph, a graph
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   * If the weights are equal amongst all groups, or if str does not appear at all, the coordinate will be at the origin
;;;   * graph has only one point
(define candidates 
  (lambda (str)
    (let* ([point (pair str weights-debates)]
           [largest (max (abs (car point)) (abs (cadr point)))]
           [pos-bound (* 1.2 largest)]
           [neg-bound (* -1 pos-bound)])
      (plot
       (list (axes)
             (points (list point)
                     #:fill-color "red"
                     #:sym 'fullcircle6
                     #:x-min neg-bound
                     #:x-max pos-bound
                     #:y-min neg-bound
                     #:y-max pos-bound))
       #:title "2016 Presidential Debates"
       #:x-label "Democrat                             Republican"
       #:y-label "Female                                 Male"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define rep-prez "/home/drallpra/Desktop/proj/reps.csv") ;address to .csv with words spoken by republican presidents
(define dem-prez "/home/drallpra/Desktop/proj/dems.csv") ;address to .csv with words spoken by democratic presidents
(define pre-prez "/home/drallpra/Desktop/proj/pre.csv") ;address to .csv with words spoken by presidents pre 1932
(define post-prez "/home/drallpra/Desktop/proj/post.csv") ;address to .csv with words spoken by presidents post 1932

        
;;; Procedure:
;;;   weights-prez
;;; Parameters:
;;;   str, a string
;;; Purpose:
;;;   weighs frequencies according to previously calculated values
;;; Produces:
;;;   weighed, a list of numbers
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   * Number of weights is always 4 
;;;   * if str does not have an associated value, the procedure assigns the value 0
;;;   * all values in weighed are real
(define weights-prez 
  (lambda (str)
    (map exact->inexact
         (list
          (/ (cadr (or (assoc-ci str (my-tally rep-prez))
                       (list "dummy-string" 0)))
             1)
          (/ (cadr (or (assoc-ci str (my-tally dem-prez))
                       (list "dummy-string" 0)))
             0.67)         
          (/ (cadr (or (assoc-ci str (my-tally post-prez))
                       (list "dummy-string" 0)))
             1)
          (/ (cadr (or (assoc-ci str (my-tally pre-prez))
                       (list "dummy-string" 0)))
             0.82)))))

;;; Procedure:
;;;   presidents
;;; Parameters:
;;;   str, a string
;;; Purpose:
;;;   plots a four-way graph which represents which group of presidents used str more
;;;   frequently in the presidential inaugural addresses relative to other groups 
;;; Produces:
;;;   graph, a graph
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   * If the weights are equal amongst all groups, or if str does not appear at all,
;;;     the coordinate will be at the origin
;;;   * graph only has one point

(define presidents
  (lambda (str)
    (let* ([point (pair str weights-prez)]
           [largest (max (abs (car point)) (abs (cadr point)))]
           [pos-bound (* 1.2 largest)]
           [neg-bound (* -1 pos-bound)])
      (plot
       (list (axes)
             (points (list point)
                     #:fill-color "red"
                     #:sym 'fullcircle6
                     #:x-min neg-bound
                     #:x-max pos-bound
                     #:y-min neg-bound
                     #:y-max pos-bound))
       #:title "Presidential Inaugural Addresses"
       #:x-label "Democrat                             Republican"
       #:y-label "Pre-1932                              Post-1932"))))