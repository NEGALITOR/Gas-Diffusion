#!/usr2/local/julia-1.8.2/bin/julia

print("Partition On [y/n]? ")
partI = readline()

partOn = false
if (partI == "y") partOn = true end


print("Enter Cube Count on One Dimension: ")
maxSize = parse(Int64, readline())

cube = zeros(Float64, maxSize, maxSize, maxSize)

diffusion_coefficient = 0.175
room_dimension = 5
speed_of_gas_molecules = 250.0
timestep = (room_dimension / speed_of_gas_molecules) / maxSize
distance_between_blocks = room_dimension / maxSize

DTerm = diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks)

cube[1,1,1] = 1.0E21

duration = 0.0
rat = 0.0

mid = ceil(Int64, maxSize*0.5)
partH = floor(Int64, maxSize*0.75)

if (partOn == true)
  for i in 0:partH
    for j in 1:maxSize
        cube[mid, maxSize - i, j] = -1
    end
  end
end

while true
  for i in 1:maxSize
    for j in 1:maxSize
      for k in 1:maxSize
        
        if(cube[i, j, k] == -1) continue end

        for l in 1:maxSize
          for m in 1:maxSize
            for n in 1:maxSize
              
              if(cube[l, m, n] == -1) continue end

              if (( ( i == l )   && ( j == m )   && ( k == n+1) ) ||  
                  ( ( i == l )   && ( j == m )   && ( k == n-1) ) ||  
                  ( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
                  ( ( i == l )   && ( j == m-1 ) && ( k == n)   ) ||  
                  ( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
                  ( ( i == l-1 ) && ( j == m )   && ( k == n)   ) )
                    
                change = (cube[i, j, k] - cube[l, m, n]) * DTerm
                cube[i, j, k] = cube[i, j, k] - change
                cube[l, m, n] = cube[l, m, n] + change
              end
            
            end
          end
        end
      end
    end
  end
  
  global duration += timestep
  
  sumVal = 0.0
  maxVal = cube[1, 1, 1]
  minVal = cube[1, 1, 1]
  
  for i in 1:maxSize
    for j in 1:maxSize
      for k in 1:maxSize
        
        if(cube[i, j, k] == -1) continue end
        maxVal = max(cube[i, j, k], maxVal)
        minVal = min(cube[i, j, k], minVal)
        sumVal += cube[i, j, k]
        
      end
    end
  end
  
  global rat = minVal / maxVal
  
  print("Time : ", duration, " ",  cube[1, 1, 1])
  print(" ", cube[maxSize, 1, 1])
  print(" ", cube[maxSize, maxSize, 1])
  print(" ", cube[maxSize, maxSize, maxSize])
  println(" ", sumVal)
  
  rat < 0.99 || break
end

println("Box equilibrated in ", duration, " seconds of simulated time.")