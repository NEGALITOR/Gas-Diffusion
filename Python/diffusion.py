# Compiling:
# python3 diffusion.py

from numpy import *
import math


# Prompts for partition ON or Off
print("Partition On [y/n]? ", end = " ")
partI = str(input())
partOn = False
if partI == 'y':
    partOn = True

# Prompts for Cube Dimension Size
print("Enter Cube Count on One Dimension: ", end = " ")
maxSize = int(input())

# Initializes Cube 3D array and Fills cube with 0.0
cube = zeros((maxSize,maxSize,maxSize), dtype=float64) 

# Initializes constants
diffusion_coefficient = 0.175
room_dimension = 5
speed_of_gas_molecules = 250.0
timestep = (room_dimension / speed_of_gas_molecules) / maxSize
distance_between_blocks = room_dimension / maxSize

DTerm = float64(diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks))

cube[0,0,0] = 1.0e21

time = 0.0
ratio = float64(0.0)

# If partition is on, place in -1 where the partition would be at
mid = int(ceil(maxSize*0.5)-1)
partH = int(floor(maxSize*0.75)+1)
if partOn == True:
    for i in range(1, partH+1):
        for j in range(0, maxSize):
            cube[mid, maxSize - i, j] = -1

# Checks every adjacent block around the current block and diffuses the mass to it
while True:
    for i in range(0, maxSize):
        for j in range(0, maxSize):
            for k in range(0, maxSize):
                
                if cube[i,j,k] == -1: continue

                for l in range(0, maxSize):
                    for m in range(0, maxSize):
                        for n in range(0, maxSize):

                            if cube[l,m,n] == -1: continue

                            if ( ( i == l )   and ( j == m )   and ( k == n+1) ) or  \
                                ( ( i == l )   and ( j == m )   and ( k == n-1) ) or  \
                                ( ( i == l )   and ( j == m+1 ) and ( k == n)   ) or  \
                                ( ( i == l )   and ( j == m-1 ) and ( k == n)   ) or  \
                                ( ( i == l+1 ) and ( j == m )   and ( k == n)   ) or  \
                                ( ( i == l-1 ) and ( j == m )   and ( k == n)   ) :
                                
                                change = float64((cube[i, j, k] - cube[l, m, n]) * DTerm)
                                cube[i, j, k] = cube[i, j, k] - change
                                cube[l, m, n] = cube[l, m, n] + change
  
    time += timestep
    
    sumVal = float64(0.0)
    maxVal = float64(cube[0, 0, 0])
    minVal = float64(cube[0, 0, 0])
    
    # Checks ratio to see if gas equilibrated
    for i in range(0, maxSize):
        for j in range(0, maxSize):
            for k in range(0, maxSize):
                if cube[i,j,k] == -1: continue
                maxVal = float64(max(cube[i, j, k], maxVal))
                minVal = float64(min(cube[i, j, k], minVal))
                sumVal += float64(cube[i, j, k])
    
    ratio = float64(minVal / maxVal)
    
    # Print out data
    print("Time : " + str(time) + " " + str(cube[0, 0, 0]), end = "")
    print(" " + str(cube[maxSize-1, 0, 0]), end = "")
    print(" " + str(cube[maxSize-1, maxSize-1, 0]), end = "")
    print(" " + str(cube[maxSize-1, maxSize-1, maxSize-1]), end = "")
    print(" " + str(sumVal))
    
    
    if ratio >= 0.99: break

print("Box equilibrated in " + str(time) + " seconds of simulated time.")
    
  
  