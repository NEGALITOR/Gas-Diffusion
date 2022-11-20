# Project - Diffusion

Diffusion consists of a room where a gas is spreading throughout the room from an upper right corner. In this project, I calculate the time it takes for a gas to fully equilibrate within 5m x 5m x 5m room utilizing 7 different languages.
The languages in question are:

- Ada
- C++
- Fortran
- Julia
- Lisp
- Python
- Rust

## Algorithm

The program initializes an array of size that the user defines which splits a 5m dimension side of the room into the specified cube amount. The algorithm then (based on if the user triggered the partition flag) inputs -1 in the middle of the cube in order to simulate a wall that would block the gas from going the other side. The height of this wall goes up to 75% of the room's height. Once created, the program starts simulating the gas by checking all adjacent blocks within its vicinity and exchanges the molar mass of the gas to that section. It iterates through and calculates the ratio of the gas to determine if the gas has equilibrated by dividing the min value by the max value. Once that passes 0.99 the simulation is finished and the time taken is given. Time is calculated by adding the timestep throughout every iteration.

## How to Compile and Run

###### Ada
> gnatmake diffusion.adb  
> ./diffusion

###### C++
> c++ diffusion.cpp  
> ./a.out

###### Fortran
> gfortran diffusion.f95  
> ./a.out

###### Julia
> chmod u+x diffusion.jl  
> ./diffusion.jl

###### Lisp
> chmod u+x diffusion.lisp  
> ./diffusion.lisp

###### Python
> python3 diffusion.py  

###### Rust
> (go inside the src folder and execute)  
> cargo build  
> cargo run

