#!/usr/bin/sbcl --script

(progn
  
  (defvar maxSize)
  (princ "Enter Cube Count on One Dimension: ")
  (terpri)
  (setf maxSize (read))
  
  (defvar cube (make-array (list maxSize maxSize maxSize) :initial-element 0))

  (defvar diffusion_coefficient 0.175)
  (defvar room_dimension 5)
  (defvar speed_of_gas_molecules 250.0)
  (defvar timestep (/ (/ room_dimension speed_of_gas_molecules) maxSize))
  (defvar distance_between_blocks (/ room_dimension maxSize))
  
  (defvar DTerm (/ (* diffusion_coefficient timestep) (* distance_between_blocks distance_between_blocks)))

  (setf (aref cube 0 0 0) 1.0E+21)
  
  (defvar pass 0)
  (defvar duration 0.0)
  (defvar rat 0.0)
  (defvar change 0)
  
  (loop do
    (loop for i from 0 to (- maxSize 1) by 1 do
      (loop for j from 0 to (- maxSize 1) by 1 do
        (loop for k from 0 to (- maxSize 1) by 1 do
          (loop for l from 0 to (- maxSize 1) by 1 do
            (loop for m from 0 to (- maxSize 1) by 1 do
              (loop for n from 0 to (- maxSize 1) by 1 do
                
                (if (or
                      (or
 	                     (or (and (and (= i l) (= j m)) (= k (+ n 1)))
		                      (and (and (= i l) (= j m)) (= k (- n 1)))
 	                     )
 	                     
 	                     (or (and (and (= i l) (= j (+ m 1))) (= k n))
		                      (and (and (= i l) (= j (- m 1))) (= k n))
 	                     )
                      )
                      
                      (or (and (and (= i (+ l 1)) (= j m)) (= k n))
 	                     (and (and (= i (- l 1)) (= j m)) (= k n))
                      ))
                    
                
                  (progn
                    (setf change (* (- (aref cube i j k) (aref cube l m n)) DTerm))
                    (setf (aref cube i j k) (- (aref cube i j k) change))
                    (setf (aref cube l m n) (+ (aref cube l m n) change))
                    (format t "Change : ~d | cube i j k : ~d | cube l m n : ~d" change (aref cube i j k) (aref cube l m n))
                    (terpri)
                  )
                
                )
                
              )
            )
          )
        )
      )
    )
    (setf duration (+ duration timestep))
    
    (defvar sumVal 0.0)
    (defvar maxVal (aref cube 0 0 0))
    (defvar minVal (aref cube 0 0 0))
    
    (loop for i from 0 to (- maxSize 1) by 1 do
      (loop for j from 0 to (- maxSize 1) by 1 do
        (loop for k from 0 to (- maxSize 1) by 1 do
          ;;;(format t "Cube IJK : ~d | maxVal : ~d | Max : ~d" (aref cube i j k) maxVal (max (aref cube i j k) maxVal))
          ;;;(terpri)
          (setf maxVal (max (aref cube i j k) maxVal))
          (setf minVal (min (aref cube i j k) minVal))
          (setf sumVal (+ sumVal (aref cube i j k)))
        )
      )
    )
    
    (setf rat (/ minVal maxVal))
    
    ;;(format t "Time: ~d ~d ~d ~d ~d ~d" duration (aref cube 0 0 0) (aref cube (- maxSize 1) 0 0) (aref cube (- maxSize 1) (- maxSize 1) 0) (aref cube (- maxSize 1) (- maxSize 1) (- maxSize 1)) sumVal)
    ;;;(terpri)
    ;;;(format t "Time : ~d | Ratio : ~d | MinVal / MaxVal : ~d / ~d" duration rat minVal maxVal)
  
  while (< rat 0.99)
  )
  
  (format t "Box equilibrated in ~d seconds of simulated time.")
)