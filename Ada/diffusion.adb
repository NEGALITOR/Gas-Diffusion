with ada.text_io, ada.integer_text_io, ada.float_text_io;
use ada.text_io, ada.integer_text_io, ada.float_text_io;

procedure diffusion is
  type Three_Dimensional_Float_Array is array (Integer range <>, Integer range <>, Integer range <>) of Long_Float;
  
  maxSize : Integer := 1;
  diffusion_coefficient : Long_Float := 0.175;
  room_dimension : Long_Float := 5.0;
  speed_of_gas_molecules : Long_Float := 250.0;
  timestep : Long_Float := 0.0;
  distance_between_blocks : Long_Float := 0.0;
  
  DTerm : Long_Float := 0.0;
  
  time : Long_Float := 0.0;
  ratio : Long_Float := 0.0;
  
  change : Long_Float := 0.0;
  
  sumVal : Long_Float := 0.0;
  minVal : Long_Float := 0.0;
  maxVal : Long_Float := 0.0;
  
begin
  
  put("Enter Cube Count on One Dimension: ");
  get(maxSize);
  
  timestep := (room_dimension / speed_of_gas_molecules) / Long_Float(maxSize);
  distance_between_blocks := room_dimension / Long_Float(maxSize);
  
  DTerm := diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks);
  
  declare
    cube :  Three_Dimensional_Float_Array ( 1..maxSize, 1..maxSize, 1..maxSize) := (others => (others => (others => 0.0)));
    
  begin
    
    cube(1, 1, 1) := Long_Float(10#1#e+21);
      
    loop
      for i in 1..maxSize loop
        for j in 1..maxSize loop
          for k in 1..maxSize loop
            for l in 1..maxSize loop
              for m in 1..maxSize loop
                for n in 1..maxSize loop
                
                  if ( (i = l) and (j = m) and (k = n+1) ) or
                     ( (i = l) and (j = m) and (k = n-1) ) or
                     ( (i = l) and (j = m+1) and (k = n) ) or
                     ( (i = l) and (j = m-1) and (k = n) ) or
                     ( (i = l+1) and (j = m) and (k = n) ) or
                     ( (i = l-1) and (j = m) and (k = n) ) then
                       
                       change := (cube(i, j, k) - cube(l, m, n)) * DTerm;
                       cube(i, j, k) := cube(i, j, k) - change;
                       cube(l, m, n) := cube(l, m, n) + change;
                       --put_line(Long_Float'Image(change));
                       
                  end if;
                  
                end loop;
              end loop;
            end loop;
          end loop;
        end loop;
      end loop;
      
      time := time + timestep;
      
      sumVal := 0.0;
      minVal := cube(1, 1, 1);
      maxVal := cube(1, 1, 1);
    
      for o in 1..maxSize loop
        for p in 1..maxSize loop
          for q in 1..maxSize loop
          
            maxVal := Long_Float'Max(cube(o, p, q), maxVal);
            minVal := Long_Float'Min(cube(o, p, q), minVal);
            sumVal := sumVal + cube(o, p, q);
          
          end loop;
        end loop;
      end loop;
      
      
      
      ratio := minVal / maxVal;
      
      --new_line;
      --put_line("Time : " & Long_Float'Image(time) & " Ratio : " & Long_Float'Image(ratio) & " MinVal/MaxVal : " & Long_Float'Image(minVal) & " / " & Long_Float'Image(maxVal));
      put(Long_Float'Image(time));
      put(" " & Long_Float'Image(cube(1, 1, 1)));
      put(" " & Long_Float'Image(cube(maxSize, 1, 1)));
      put(" " & Long_Float'Image(cube(maxSize, maxSize, 1)));
      put(" " & Long_Float'Image(cube(maxSize, maxSize, maxSize)));
      put_line(" " & Long_Float'Image(sumVal));
      
      exit when ratio >= 0.99;
        
    end loop;
    
    put_line("Box equilibrated in " & Long_Float'Image(time) & " seconds of simulated time.");
    
  end;


end diffusion;