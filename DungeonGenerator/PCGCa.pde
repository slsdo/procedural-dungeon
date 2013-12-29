/* Procedural Content Generation
   Cellular Automata
   Based on algorithm by Jim Babcock
   http://www.jimrandomh.org/misc/caves.html */

class PCGCa extends PCG {
  byte[][] cagrid; // Grid array
  int r1_cutoff = 5;
  int r2_cutoff = 2;
  int iter1;
  int iter2;
  int prob;
    
  PCGCa()
  {
  }

  void updateParam(int g_width, int g_height, int w_fill, int it1, int it2)
  {
    super.updateParam(g_width, g_height);
    prob = w_fill; // Fill percentage
    iter1 = it1; // Number of iterations
    iter2 = it2; // Number of iterations for well-formedness
  }
  
  void generatePCGCa(byte[][] g)
  {
    super.generatePCG(g); // Init grid 
    
    initMap(); // Fill map randomly
    
    // CA iterate
    for (int i = 0; i < iter1; i++) {
      cellularAutomata(r1_cutoff, r2_cutoff); 
    }
    // Cleanup interate
    for (int i = 0; i < iter2; i++) {
      cellularAutomata(r1_cutoff, -1); 
    }
  }
  
  byte randomPick()
  {
    // Return a random value based on probability
    if (int(random(100)) > (100 - prob)) return 0;
    else return 1;    
  }
  
  void initMap()
  {
    cagrid = new byte[pcgrid_width][pcgrid_height];
    // Initialize random grid
    for (int j = 0; j < pcgrid_height - 1; j++) {
      for (int i = 0; i < pcgrid_width - 1; i++) {
        pcgrid[i][j] = randomPick();
      }
    }
    // Initialize 2nd grid
    for (int j = 0; j < pcgrid_height; j++) {
      for (int i = 0; i < pcgrid_width; i++) {
        cagrid[i][j] = 0;
      }
    }
    // Set walls
    for (int i = 0; i < pcgrid_width; i++) { pcgrid[i][0] = 0 ; pcgrid[i][pcgrid_height - 1] = 0; }
    for (int j = 0; j < pcgrid_height; j++) { pcgrid[0][j] = 0; pcgrid[pcgrid_width - 1][j] = 0; }
  }

  void cellularAutomata(int r1, int r2)
  {
    for (int j = 1; j < pcgrid_height - 1; j++) {
      for (int i = 1; i < pcgrid_width - 1; i++) {
        int adjcount_r1 = 0; // Adjacent tiles within 1 step of P
        int adjcount_r2 = 0; // Adjacent tiles within 2 step of P
        
        for (int jj = -1; jj <= 1; jj++) {
          for (int ii = -1; ii <= 1; ii++) {
            // Count number of walls around T within radius 1
            if (pcgrid[i + ii][j + jj] != 1) adjcount_r1++;
          }
        }
        for (int jj = j - 2; jj <= j + 2; jj++) {
          for (int ii = i - 2; ii <= i + 2; ii++) {
            // Count number of walls around T within radius 2
            if (abs(ii - i) == 2 && abs(jj - j) == 2) continue; // If is n2
            if (ii < 0 || jj < 0 || ii >= pcgrid_width || jj >= pcgrid_height) continue; // Bounded
            if (pcgrid[ii][jj] != 1) adjcount_r2++;
          }
        }
        
        if (adjcount_r1 >= r1 || adjcount_r2 <= r2) cagrid[i][j] = 0;
 	else cagrid[i][j] = 1;
      }
    }
    
    for (int j = 1; j < pcgrid_height - 1; j++) {
      for (int i = 1; i < pcgrid_width - 1; i++) {
        pcgrid[i][j] = cagrid[i][j];
      }
    }  
  }
}
