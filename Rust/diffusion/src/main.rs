extern crate ndarray;
use ndarray::Array3;
use math::round::floor;
use math::round::ceil;


fn main() {
    
    println!("Partition On [y/n]? ");
    let mut part_iraw = String::new();
    let _b2 = std::io::stdin().read_line(&mut part_iraw).unwrap();
    let part_i = part_iraw.trim();
    
    let mut _part_on = false;
    if part_i == "y" {_part_on = true}

    println!("Enter Cube Count on One Dimension: ");
    let mut input = String::new();
    let _b1 = std::io::stdin().read_line(&mut input).unwrap();
    let trimmed = input.trim();

    let max_size = trimmed.parse::<usize>().unwrap();
    
    let mut cube = Array3::<f64>::zeros((max_size, max_size, max_size));
    
    let diffusion_coefficient = 0.175;
    let room_dimension = 5 as f64;
    let speed_of_gas_molecules = 250.0;
    let timestep = (room_dimension / speed_of_gas_molecules) / max_size as f64;
    let distance_between_blocks = room_dimension / max_size as f64;

    let d_term = diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks);

    cube[[0,0,0]] = 1.0e+21 as f64;

    let mut time = 0.0 as f64;
    let mut ratio;

    let mid = (ceil(max_size as f64 *0.5 , 0)-1.0) as usize;
    let part_h = (floor(max_size as f64 *0.75,0)+1.0) as usize;
    if _part_on == true
    {
        for i in 1..part_h+1 {
            for j in 0..max_size
            {
                cube[[mid, max_size - i, j]] = -1.0;
            }
        }
    }


    loop {
        for i in 0..max_size {
            for j in 0..max_size {
                for k in 0..max_size {

                    if cube[[i, j, k]] == -1.0 {continue;}

                    for l in 0..max_size {
                        for m in 0..max_size {
                            for n in 0..max_size {

                                if cube[[l, m, n]] == -1.0 {continue;}

                                if ( ( i == l )   && ( j == m )   && ( k == n+1 ) ) ||  
                                    ( ( i == l )   && ( j == m )   && ( k == n-1) ) ||  
                                    ( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
                                    ( ( i == l )   && ( j == m-1 ) && ( k == n)   ) ||  
                                    ( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
                                    ( ( i == l-1 ) && ( j == m )   && ( k == n)   )
                                {
                                    let change = (cube[[i, j, k]] - cube[[l, m, n]]) * d_term;
                                    cube[[i, j, k]] = cube[[i, j, k]] - change;
                                    cube[[l, m, n]] = cube[[l, m, n]] + change;
                                    //println!("i: {}", i);
                                }
                            }
                        }
                    }
                }
            }
        }

        time = time + timestep;

        let mut _sum_val = 0.0 as f64;
        let mut max_val = cube[[0, 0, 0]] as f64;
        let mut min_val = cube[[0, 0, 0]] as f64;

        for i in 0..max_size {
            for j in 0..max_size {
                for k in 0..max_size {

                    if cube[[i, j, k]] == -1.0 {continue;}
                    max_val = max_val.max(cube[[i, j, k]]);
                    min_val = min_val.min(cube[[i, j, k]]);
                    _sum_val = cube[[i, j, k]];
                }
            }
        }

        ratio = min_val/max_val as f64;

        print!("Time : {} {}", time, cube[[0, 0, 0]]);
        print!(" {}", cube[[max_size-1, 0, 0]]);
        print!(" {}", cube[[max_size-1, max_size-1, 0]]);
        print!(" {}", cube[[max_size-1, max_size-1, max_size-1]]);
        println!(" {}", _sum_val);

        if ratio >= 0.99 {break;}
    }

    println!("Box equilibrated in {} seconds of simulated time.", time);
}