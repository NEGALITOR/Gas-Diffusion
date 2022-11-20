-- Compiling:
-- gnatmake diffusion.adb
-- ./diffusion

with ada.text_io, ada.integer_text_io, ada.float_text_io;
use ada.text_io, ada.integer_text_io, ada.float_text_io;

procedure diffusion is

  -- Variables

  type Three_Dimensional_Float_Array is array (Integer range <>, Integer range <>, Integer range <>) of Long_Float;
  
  partI : Character := ' ';
  maxSize : Integer := 1;

  partOn : Boolean := False;
  mid : Integer := 0;
  partH : Integer := 0;
  
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
  
  -- Prompts for partition ON or Off
  put("Partition On [y/n]? ");
  get(partI);
  if partI = 'y' then partOn := True; end if;

  -- Prompts for Cube Dimension Size
  put("Enter Cube Count on One Dimension: ");
  get(maxSize);
  
  -- Initializes constants
  timestep := (room_dimension / speed_of_gas_molecules) / Long_Float(maxSize);
  distance_between_blocks := room_dimension / Long_Float(maxSize);
  
  DTerm := diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks);
  
  declare
    -- Initializes Cube 3D array and Fills cube with 0.0
    cube :  Three_Dimensional_Float_Array ( 1..maxSize, 1..maxSize, 1..maxSize) := (others => (others => (others => 0.0)));
    
  begin
    
    cube(1, 1, 1) := Long_Float(10#1#e+21);

    -- If partition is on, place in -1 where the partition would be at
    mid := Integer(Float'Ceiling(Float(maxSize*0.5)));
    partH := Integer(Float'Floor(Float(maxSize*0.75)));
    if partOn = True then
      for i in 0..partH loop
        for j in 1..maxSize loop

          cube(mid, maxSize - i, j) := -1.0;

        end loop;
      end loop;
    end if;
    
    -- Checks every adjacent block around the current block and diffuses the mass to it
    loop
      for i in 1..maxSize loop
        for j in 1..maxSize loop
          for k in 1..maxSize loop

            if cube(i, j, k) = -1.0 then goto ContinueO; end if;

            for l in 1..maxSize loop
              for m in 1..maxSize loop
                for n in 1..maxSize loop

                  if cube(l, m, n) = -1.0 then goto ContinueTW; end if;

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
                  << ContinueTW >>
                  put("");
                end loop;
              end loop;
            end loop;
            << ContinueO >>
            put("");
          end loop;
        end loop;
      end loop;
      
      time := time + timestep;
      
      sumVal := 0.0;
      minVal := cube(1, 1, 1);
      maxVal := cube(1, 1, 1);

      -- Checks ratio to see if gas equilibrated
      for i in 1..maxSize loop
        for j in 1..maxSize loop
          for k in 1..maxSize loop

            if cube(i, j, k) = -1.0 then goto ContinueTH; end if;
            maxVal := Long_Float'Max(cube(i, j, k), maxVal);
            minVal := Long_Float'Min(cube(i, j, k), minVal);
            sumVal := sumVal + cube(i, j, k);
            << ContinueTH >>
            put("");

          end loop;
        end loop;
      end loop;
      
      ratio := minVal / maxVal;
      
      -- Print out data
      put("Time : " & Long_Float'Image(time));
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