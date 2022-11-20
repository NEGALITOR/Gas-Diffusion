#!/usr/bin/sbcl --script

#|
# Compiling
# chmod u+x diffusion.lisp
# ./diffusion.lisp
|#

;;;Prompts for partition ON or Off
(defvar partOn 0)
(defvar partI)
(princ "Partition On [y/n]? ")
(terpri)
(setf partI (read-char))
(if (string-equal partI "y") (setf partOn 1))

;;;Prompts for Cube Dimension Size
(defvar maxSize)
(princ "Enter Cube Count on One Dimension: ")
(terpri)
(setf maxSize (read))

;;;Initializes Cube 3D array and fills cube with 0.0
(defvar cube (make-array (list maxSize maxSize maxSize) :initial-element 0))

;;;Initializes constants
(defvar diffusion_coefficient 0.175)
(defvar room_dimension 5)
(defvar speed_of_gas_molecules 250.0)
(defvar timestep (/ (/ room_dimension speed_of_gas_molecules) maxSize))
(defvar distance_between_blocks (/ room_dimension maxSize))

(defvar DTerm (/ (* diffusion_coefficient timestep) (* distance_between_blocks distance_between_blocks)))

(setf (aref cube 0 0 0) 1.0E+21)

(defvar duration 0.0)
(defvar rat 0.0)

(defvar mid (- (ceiling (* maxSize 0.5)) 1))
(defvar partH (+ (floor (* maxSize 0.75)) 1))

;;;If partition is on, place in -1 where the partition would be at
(if (= partOn 1)
  (progn
    (loop for i from 1 to partH by 1 do
      (loop for j from 0 to (- maxSize 1) by 1 do
        (setf (aref cube mid (- maxSize i) j) -1)
      )
    )
  )

)

(defvar change 0.0)

(defvar sumVal 0.0)
(defvar maxVal 0.0)
(defvar minVal 0.0)

;;;Checks every adjacent block around the current block and diffuses the mass to it
(loop do
  
  (loop for i from 0 to (- maxSize 1) do
    (loop for j from 0 to (- maxSize 1) do
      (loop for k from 0 to (- maxSize 1) do

        (if (/= (aref cube i j k) -1)
        
          (loop for l from 0 to (- maxSize 1) do
            (loop for m from 0 to (- maxSize 1) do
              (loop for n from 0 to (- maxSize 1) do
                
                (if (/= (aref cube l m n) -1)
                
                  (if (or (or
                      (or (and (= i l) (and (= j m) (= k (+ n 1))) )
                          (and (= i l) (and (= j m) (= k (- n 1))) ))
                      (or (and (= i l) (and (= j (+ m 1)) (= k n)) )
                          (and (= i l) (and (= j (- m 1)) (= k n)) )))
                      (or (and (= i (+ l 1)) (and (= j m) (= k n)) )
                          (and (= i (- l 1)) (and (= j m) (= k n)) )))

                      (progn
                          (setf change (* (- (aref cube i j k) (aref cube l m n)) DTerm))
                          (setf (aref cube i j k) (- (aref cube i j k) change))
                          (setf (aref cube l m n) (+ (aref cube l m n) change))
                      )
                  )
                )
                
              )
                
            )
          )
        )
        
      )
    )
  )

  (setf duration (+ duration timestep))
  
  (setf sumVal 0)
  (setf maxVal (aref cube 0 0 0))
  (setf minVal (aref cube 0 0 0))
  
  ;;;Checks ratio to see if gas equilibrated
  (loop for i from 0 to (- maxSize 1) do
    (loop for j from 0 to (- maxSize 1) do
      (loop for k from 0 to (- maxSize 1) do
        (if (/= (aref cube i j k) -1)
          (progn
            (setf maxVal (max (aref cube i j k) maxVal))
            (setf minVal (min (aref cube i j k) minVal))
            (setf sumVal (+ sumVal (aref cube i j k)))
          )
        )
      )
    )
  )
  
  (setf rat (/ minVal maxVal))
  
  ;;;Print out data
  (format t "Time: ~d ~d ~d ~d ~d ~d" duration (aref cube 0 0 0) (aref cube (- maxSize 1) 0 0) (aref cube (- maxSize 1) (- maxSize 1) 0) (aref cube (- maxSize 1) (- maxSize 1) (- maxSize 1)) sumVal)
  (terpri)

  (if (>= rat 0.99) (return))
)

(terpri)
(format t "Box equilibrated in ~d seconds of simulated time." duration)

