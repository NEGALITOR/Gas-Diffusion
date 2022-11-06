#include <iostream>

using namespace std;

int main()
{
  
  int maxSize;
  cout << "Enter Cube Count on One Dimension: ";
  cin >> maxSize;
  
  double cube[maxSize][maxSize][maxSize]{};
  
  double diffusion_coefficient = 0.175; 
  double room_dimension = 5;
  double speed_of_gas_molecules = 250.0;          // Based on 100 g/mol gas at RT
  double timestep = (room_dimension / speed_of_gas_molecules) / maxSize; // h in seconds
  double distance_between_blocks = room_dimension / maxSize;

  double DTerm = diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks);
  
  cube[0][0][0] = 1.0e21;
  
  int pass = 0;
  double time = 0.0;
  double ratio = 0.0;
  
  do
  {
    for (int i = 0; i < maxSize; i++) {
      for (int j = 0; j < maxSize; j++) {
        for (int k = 0; k < maxSize; k++) {
          for (int l = 0; l < maxSize; l++) {
            for (int m = 0; m < maxSize; m++) {
              for (int n = 0; n < maxSize; n++)
              {
                
                if (( ( i == l )   && ( j == m )   && ( k == n+1) ) ||  
                    ( ( i == l )   && ( j == m )   && ( k == n-1) ) ||  
                    ( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
                    ( ( i == l )   && ( j == m-1 ) && ( k == n)   ) ||  
                    ( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
                    ( ( i == l-1 ) && ( j == m )   && ( k == n)   ) ) 
                {
                  double change = (cube[i][j][k] - cube[l][m][n]) * DTerm;
                  cube[i][j][k] = cube[i][j][k] - change;
                  cube[l][m][n] = cube[l][m][n] + change;
                  
                }
              }
            }
          }
        }
      }
    }
    
    time += timestep;
    
    double sumVal = 0.0;
    double minVal = cube[0][0][0];
    double maxVal = cube[0][0][0];
    
    for (int i = 0; i < maxSize; i++) {
      for (int j = 0; j < maxSize; j++) {
        for (int k = 0; k < maxSize; k++)
        {
          maxVal = max(cube[i][j][k], maxVal);
          minVal = min(cube[i][j][k], minVal);
          sumVal += cube[i][j][k];
        }
      }
    }
    
    ratio = minVal / maxVal;
    
    cout << "Time : " << time << " " << cube[0][0][0];
    cout << " " << cube[maxSize-1][0][0];
    cout << " " << cube[maxSize-1][maxSize-1][0];
    cout << " " << cube[maxSize-1][maxSize-1][maxSize-1];
    cout << " " << sumVal << endl;
  
  } while (ratio < 0.99);
  
  cout << "Box equilibrated in " << time << " seconds of simulated time." << endl;
  
  return 0;
}