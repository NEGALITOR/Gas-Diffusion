PROGRAM diffusion
  
  INTEGER :: maxSize, once, partH, partOn, mid
  CHARACTER :: partI
  REAL (kind=8), dimension(:,:,:), allocatable :: cube
  REAL (kind=8) :: diffusion_coefficient, room_dimension, speed_of_gas_molecules, timestep, distance_between_blocks, DTerm, &
                   time, ratio, change, sumValue, maxValue, minValue
  
  
  partOn = 0
  write(*, '(A)', advance="no") "Partition On [y/n]? "
  read(*,*) partI
  if(partI == 'y') partOn = 1

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
  
  time = 0.0
  ratio = 0.0

  mid = CEILING(maxSize*0.5)
  partH = FLOOR(maxSize*0.75)

  if (partOn == 1) then
    do i = 0, partH
      do j = 1, maxSize
        
        cube(mid, maxSize - i, j) = -1

      END do
    END do
  END if

  do while (0 == 0)

    do i = 1, maxSize
      do j = 1, maxSize
        do k = 1, maxSize

          if (cube(i, j, k) == -1) cycle

          do l = 1, maxSize
            do m = 1, maxSize
              do n = 1, maxSize

                if (cube(l, m, n) == -1) cycle
                
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

          if (cube(i, j, k) == -1) cycle
          maxValue = MAX(cube(i, j, k), maxValue)
          minValue = MIN(cube(i, j, k), minValue)
          sumValue = sumValue + cube(i, j, k)
        
        END do
      END do
    END do
    
    ratio = minValue / maxValue
    
    write(*, '(A, F0.3, A, E10.4)', advance="no") "Time : ", time, " ",  cube(1, 1, 1)
    write(*, '(A, E10.4)', advance="no") " ", cube(maxSize, 1, 1)
    write(*, '(A, E10.4)', advance="no") " ", cube(maxSize, maxSize, 1)
    write(*, '(A, E10.4)', advance="no") " ", cube(maxSize, maxSize, maxSize)
    write(*, '(A, E10.4)') " ", sumValue
    
    if (ratio > 0.99) exit;

  END do
  
  write(*, '(A, F0.3, A)') "Box equilibrated in ", time, " seconds of simulated time."
  
  if ( allocated(cube) ) deallocate(cube)
  
END PROGRAM diffusion