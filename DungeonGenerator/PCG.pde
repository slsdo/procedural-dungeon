/* Procedural Content Generation
   Empty grid
   For testing pathfinding algorithms
   - This is really just an empty grid used for test purposes */

class PCG {
  byte[][] pcgrid; // Grid array
  int pcgrid_width; // Grid width
  int pcgrid_height; // Grid height
  
  PCG()
  {
  }
  
  void updateParam(int g_width, int g_height)
  {
    pcgrid_width = g_width; // Get grid length
    pcgrid_height = g_height; // Get grid width
  }
  
  void generatePCG(byte[][] g)
  {
    pcgrid = g; // Copy grid
  }
  
  boolean bounded(int x, int y)
  {
    // Check if cell is inside grid
    if (x < 0 || x >= pcgrid_width || y < 0 || y >= pcgrid_height) return false;
    return true;
  }  
  
  boolean blocked(int x, int y, int type)
  {
    // Check if cell is occupied
    if (bounded(x, y) && pcgrid[x][y] == type) return true;
    return false;
  }
}
