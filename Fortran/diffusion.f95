PROGRAM diffusion
  
  INTEGER :: maxSize, pass, once
  REAL (kind=8), dimension(:,:,:), allocatable :: cube
  REAL (kind=8) :: diffusion_coefficient, room_dimension, speed_of_gas_molecules, timestep, distance_between_blocks, DTerm, &
                   time, ratio, change, sumValue, maxValue, minValue
  
  
  write(*, '(A)', advance="no") "Enter Cube Count on One Dimension: "
  read(*,*) maxSize
  
  allocate (cube(maxSize, maxSize, maxSize), stat=ierr)
  
  if (ierr /= 0) then
    print *, "Could not allocate memory - halting run."
    STOP
  END if
  
  cube = 0.0
  
  diffusion_coefficient = 0.175
  room_dimension = 5
  speed_of_gas_molecules = 250.0
  timestep = (room_dimension / speed_of_gas_molecules) / maxSize
  distance_between_blocks = room_dimension / maxSize
  DTerm = diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks)
  
  cube(1,1,1) = 1.0E21
  
  pass = 0
  time = 0.0
  ratio = 0.0
  
  once = 0
  
  do while ((once == 0) .OR. ratio < 0.99)
    once = 1
    do i = 1, maxSize
      do j = 1, maxSize
        do k = 1, maxSize
          do l = 1, maxSize
            do m = 1, maxSize
              do n = 1, maxSize
                
                if (( ( i == l )   .AND. ( j == m )   .AND. ( k == n+1) ) .OR. &
                    ( ( i == l )   .AND. ( j == m )   .AND. ( k == n-1) ) .OR. &
                    ( ( i == l )   .AND. ( j == m+1 ) .AND. ( k == n)   ) .OR. &
                    ( ( i == l )   .AND. ( j == m-1 ) .AND. ( k == n)   ) .OR. &
                    ( ( i == l+1 ) .AND. ( j == m )   .AND. ( k == n)   ) .OR. &
                    ( ( i == l-1 ) .AND. ( j == m )   .AND. ( k == n)   ) ) then
                    
                    change = (cube(i, j, k) - cube(l, m, n)) * DTerm
                    cube(i, j, k) = cube(i, j, k) - change
                    cube(l, m, n) = cube(l, m, n) + change
                END if
                
              END do
            END do
          END do
        END do
      END do
    END do
    
    time = time + timestep
    
    sumValue = 0.0
    maxValue = cube(1, 1, 1)
    minValue = cube(1, 1, 1)
    
    do i = 1, maxSize
      do j = 1, maxSize
        do k = 1, maxSize
          maxValue = MAX(cube(i, j, k), maxValue)
          minValue = MIN(cube(i, j, k), minValue)
          sumValue = sumValue + cube(i, j, k)
        
        END do
      END do
    END do
    
    ratio = minValue / maxValue
    
    write(*, '(A, F0.5, A, F0.5)', advance="no") "Time : ", time, " ",  cube(1, 1, 1)
    write(*, '(A, F0.5)', advance="no") " ", cube(maxSize, 1, 1)
    write(*, '(A, F0.5)', advance="no") " ", cube(maxSize, maxSize, 1)
    write(*, '(A, F0.5)', advance="no") " ", cube(maxSize, maxSize, maxSize)
    write(*, '(F5.1)') sumValue
    
  END do
  
  write(*, '(A, F5.1, A)') "Box equilibrated in ", time, " seconds of simulated time."
  
  if ( allocated(cube) ) deallocate(cube)
  
END PROGRAM diffusion