class World {
  PCG pcg; // Procedural Content Generation grid
  PCGBasic pcgb; // Procedural Content Generation grid Basic
  PCGCa pcgca; // Procedural Content Generation grid Cellular Automata
  PCGBSP pcgbsp; // Procedural Content Generation grid BSP
  PCGBuild pcgbd; // Procedural Content Generation grid Grow
  int pcg_type; // PCG type
  
  byte[][] grid; // Grid array
  boolean show_grid = true; // Show grid
  int grid_width; // Grid width
  int grid_height; // Grid height
  
  boolean debug = true; // Debug mode
  
  // World parameters  
  World()
  {
    generateWorld(1, 40, 30);
  }
  
  void generateWorld(int p_t, int g_w, int g_h)
  {
    pcg_type = p_t; // PGC type
    grid_width = g_w; // Grid width
    grid_height = g_h; // Grid height
    
    initGrid(); // Initialize empty grid
    
    // Generate PCG
    switch (pcg_type) {
      case 0: pcg = new PCG();
              pcg.updateParam(grid_width, grid_height);
              pcg.generatePCG(grid);
              break;
      case 1: pcgb = new PCGBasic();
              pcgb.updateParam(grid_width, grid_height, room_type, room_min_size, room_max_size, corridor_num, corridor_weight, turning_weight);
              pcgb.generatePCGBasic(grid);
              break;
      case 2: pcgca = new PCGCa();
              pcgca.updateParam(grid_width, grid_height, wall_fill, generate_iter, cleanup_iter);
              pcgca.generatePCGCa(grid);
              break;
      case 3: pcgbsp = new PCGBSP();
              pcgbsp.updateParam(grid_width, grid_height, min_room_num, min_room_size);
              pcgbsp.generatePCGBSP(grid);
              break;
      case 4: pcgbd = new PCGBuild();
              pcgbd.updateParam(grid_width, grid_height, max_rm_w, max_rm_h, max_corr_l, obj_num);
              pcgbd.generatePCGBuild(grid);
              break;
    }
  }
  
  void randomWorld()
  {
    g_layout = int(random(1, 4));
    g_width = int(random(1, 50));
    g_height = int(random(1, 50));
    generateWorld(g_layout, g_width, g_height);
  }
  
  void updateParam(boolean g_s, boolean d_s)
  {
    show_grid = g_s; // Display grid
    debug = d_s; // Display debug info
  }
  
  void initGrid()
  {
    grid = new byte[grid_width][grid_height]; 
    
    for (int j = 0; j < grid_height; j++) {
      for (int i = 0; i < grid_width; i++) {
        grid[i][j] = 0; // Initialize all cell as empty
      }
    }
  }
}
