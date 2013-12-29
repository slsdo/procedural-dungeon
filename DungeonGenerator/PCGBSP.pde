/* Procedural Content Generation
   BSP Dungeon generation
   Based on BSP algorithm from RogueBasin
   http://roguebasin.roguelikedevelopment.org/index.php/Basic_BSP_Dungeon_generation */

class PCGBSP extends PCG {
  int room_num; // Minimum number of rooms
  int room_size; // Minimum size of rooms
  ArrayList rooms;
  
  PCGBSP()
  {
  }
  
  void updateParam(int g_width, int g_height, int r_num, int r_size)
  {
    super.updateParam(g_width, g_height);
    // Room num
    if (r_num > (pcgrid_width*pcgrid_height)/50) r_num = (pcgrid_width*pcgrid_height)/50;
    room_num = r_num;
    
    // Min room size
    if (r_size > pcgrid_width*pcgrid_height) r_size = pcgrid_width*pcgrid_height;
    room_size = r_size;
  }
  
  void generatePCGBSP(byte[][] g)
  {
    super.generatePCG(g); // Init grid 
    
    rooms = new ArrayList();
    BSPRoom root_room = new BSPRoom(0, 0, pcgrid_width, pcgrid_height, room_size);
    rooms.add(root_room); // Populate rectangle store with root area
    
    while (rooms.size() < room_num) { // Split the grid
      int split_index = int(random(rooms.size())); // Choose a random room to split
      BSPRoom split_room = (BSPRoom) rooms.get(split_index);
      if (split_room.splitBSP()) { // Attempt to split
        rooms.add(split_room.left_child);
        rooms.add(split_room.right_child);      
      } 
    }
    for (int n = 0; n < rooms.size(); n++) {
      // Go through each leaf node and create a room
      BSPRoom rm = (BSPRoom) rooms.get(n);
      
      if (rm.left_child != null || rm.right_child != null) continue; // If has child then go to next iteration
      
      rm.generateBSPRoom();
      
      for (int i = rm.bsp_x; i < rm.bsp_x + rm.bsp_width; i++) {
        pcgrid[i][rm.bsp_y] = 5;
        pcgrid[i][rm.bsp_y + rm.bsp_height - 1] = 5;
      }
      for (int j = rm.bsp_y; j < rm.bsp_y + rm.bsp_height; j++) {
        pcgrid[rm.bsp_x][j] = 5;
        pcgrid[rm.bsp_x + rm.bsp_width - 1][j] = 5;
      }
    }
    for (int n = 0; n < rooms.size(); n++) {
      // Go through each leaf node and create a room
      BSPRoom rm = (BSPRoom) rooms.get(n);
      
      if (rm.left_child != null || rm.right_child != null) continue; // If has child then go to next iteration
      
      // Horizontal walls
      for (int i = rm.room_x1; i <= rm.room_x2; i++) {
        pcgrid[i][rm.room_y1] = 2; // North wall
        pcgrid[i][rm.room_y2] = 2; // South wall
      }
      // Vertical walls
      for (int j = rm.room_y1; j <= rm.room_y2; j++) {
        pcgrid[rm.room_x1][j] = 2; // West wall
        pcgrid[rm.room_x2][j] = 2; // East wall
      }
        // Create room
        for (int j = rm.room_y1 + 1; j < rm.room_y2; j++) {
          for (int i = rm.room_x1 + 1; i < rm.room_x2; i++) {
              pcgrid[i][j] = 1; // Fill room
          }
        }
    }
    
    connectBSPRoom(root_room); // Connect room with corridors
  }

  void connectBSPRoom(BSPRoom room)
  {
    // If has children, connect children first
    if (room.left_child != null) {
      connectBSPRoom(room.left_child);
      connectBSPRoom(room.right_child);
    }
    
    // If leaf node, stop
    if (room.left_child == null) return;
    
    // Connect rooms based on split direction
    if (room.horizontal) { // If split horizontally
      int c_x = room.bsp_x + room.bsp_width/2; // Node midpoint
      if (room.left_child.filled && room.right_child.filled) {
        // If both children are not split, create corridor from south wall of left child to north wall of right child
        int offset = checkCorner(c_x, -1,  room.left_child.room_y2, room.right_child.room_y1, room.horizontal);
        for (int j = room.left_child.room_y2; j <= room.right_child.room_y1; j++) {
          if (pcgrid[c_x + offset][j] == 1 || pcgrid[c_x + offset][j] == 4) break;
          else pcgrid[c_x + offset][j] = 4;
        }
      }
      else if (room.left_child.filled && !room.right_child.filled) {
        // If left child is not split, create corridor from south wall of left child to midpoint of right child
        int offset = checkCorner(c_x, -1,  room.left_child.room_y2, room.bsp_y + room.bsp_height - 1, room.horizontal);
        for (int j = room.left_child.room_y2; j < room.bsp_y + room.bsp_height; j++) {
          if (pcgrid[c_x + offset][j] == 1 || pcgrid[c_x + offset][j] == 4) break;
          else pcgrid[c_x + offset][j] = 4;
        }
      }
      else if (!room.left_child.filled && room.right_child.filled) {
        // If right child is not split, create corridor from north wall of right child to midpoint of left child
        int offset = checkCorner(c_x, -1, room.right_child.room_y1, room.bsp_y, room.horizontal);
        for (int j = room.right_child.room_y1; j >= room.bsp_y; j--) {
          if (pcgrid[c_x + offset][j] == 1 || pcgrid[c_x + offset][j] == 4) break;
          else pcgrid[c_x + offset][j] = 4;
        }
      }
      else {
        // If both children split, create corridor from midpoint of left child to midpoint of right child
        int offset = checkCorner(c_x, -1, room.left_child.bsp_height/2, room.left_child.bsp_height + room.right_child.bsp_height - 1, room.horizontal);
        for (int j = room.left_child.bsp_height/2; j < room.left_child.bsp_height + room.right_child.bsp_height; j++) {
          // Stop if we're in the second child and have reached a room tile or corridor tile
          if ((pcgrid[c_x + offset][j] == 1 || pcgrid[c_x + offset][j] == 4) && j > room.right_child.bsp_y) break;
          else pcgrid[c_x + offset][j] = 4;
        }
      }
    }
    else { // If split vertically
      int c_y = room.bsp_y + room.bsp_height/2; // Node midpoint
      if (room.left_child.filled && room.right_child.filled) {
        // If both children are not split, create corridor from right wall of left child to left wall of right child
        int offset = checkCorner(room.left_child.room_x2, room.right_child.room_x1, c_y, -1, room.horizontal);
        for (int i = room.left_child.room_x2; i <= room.right_child.room_x1; i++) {
          if (pcgrid[i][c_y + offset] == 1 || pcgrid[i][c_y + offset] == 4) break;
          else pcgrid[i][c_y + offset] = 4;
        }
      }
      else if (room.left_child.filled && !room.right_child.filled) {
        // If left child is not split, create corridor from right wall of left child to midpoint of right child
        int offset = checkCorner(room.left_child.room_x2, room.bsp_x + room.bsp_width - 1, c_y, -1, room.horizontal);
        for (int i = room.left_child.room_x2; i < room.bsp_x + room.bsp_width; i++) {
          if (pcgrid[i][c_y + offset] == 1 || pcgrid[i][c_y + offset] == 4) break;
          else pcgrid[i][c_y + offset] = 4;
        }
      }
      else if (!room.left_child.filled && room.right_child.filled) {
        // If right child is not split, create corridor from left wall of right child to midpoint of left child
        int offset = checkCorner(room.right_child.room_x1, room.left_child.bsp_x, c_y, -1, room.horizontal);
        for (int i = room.right_child.room_x1; i >= room.left_child.bsp_x; i--) {
          if (pcgrid[i][c_y + offset] == 1 || pcgrid[i][c_y + offset] == 4) break;
          else pcgrid[i][c_y + offset] = 4;
        }
      }
      else {
        // If both children split, create corridor from midpoint of left child to midpoint of right child
        int offset = checkCorner(room.left_child.bsp_width/2, room.left_child.bsp_width + room.right_child.bsp_width - 1, c_y, -1, room.horizontal);
        for (int i = room.left_child.bsp_width/2; i < room.left_child.bsp_width + room.right_child.bsp_width; i++) {
          // Stop if we're in the second child and have reached a room tile or corridor tile
          if ((pcgrid[i][c_y + offset] == 1 || pcgrid[i][c_y + offset] == 4) && i > room.right_child.bsp_x) break;
          else pcgrid[i][c_y + offset] = 4;
        }
      }
    }
  }
  
  int checkCorner(int x1, int x2, int y1, int y2, boolean horizontal)
  {
    // Check if the corridor lands on a room corner
    if (horizontal) {
      if (pcgrid[x1][y1] == 2 && pcgrid[x1 + 1][y1] == 1) return 1; // Top right
      if (pcgrid[x1][y2] == 2 && pcgrid[x1 + 1][y2] == 1) return 1; // Bottom right
      if (pcgrid[x1][y1] == 2 && pcgrid[x1 - 1][y1] == 1) return -1; // Top left
      if (pcgrid[x1][y2] == 2 && pcgrid[x1 - 1][y2] == 1) return -1; // Bottom left
    }
    else {
      if (pcgrid[x1][y1] == 2 && pcgrid[x1][y1 + 1] == 1) return 1; // Bottom left
      if (pcgrid[x2][y1] == 2 && pcgrid[x2][y1 + 1] == 1) return 1; // Bottom right
      if (pcgrid[x1][y1] == 2 && pcgrid[x1][y1 - 1] == 1) return -1; // Top left
      if (pcgrid[x2][y1] == 2 && pcgrid[x2][y1 - 1] == 1) return -1; // Top right
    }
    return 0;      
  }
}

class BSPRoom {
  int min_size; // Default should be 5
  int bsp_x;
  int bsp_y;
  int bsp_width;
  int bsp_height;
  int room_x1;
  int room_y1;
  int room_x2;
  int room_y2;
  boolean filled = false;
  boolean horizontal; // Direction of split
  BSPRoom left_child;
  BSPRoom right_child;
  
  BSPRoom(int x, int y, int w, int h, int r_size)
  {
    bsp_x = x;
    bsp_y = y;
    bsp_width = w;
    bsp_height = h;
    min_size = r_size;
  }
  
  boolean splitBSP()
  {    
    if (left_child != null) return false; // If already split, bail out
        
    if (int(random(100)) > 50) horizontal = true;
    else horizontal = false;
    
    int max_size = (horizontal ? bsp_height : bsp_width) - min_size; // Maximum height/width we can split off
    if (max_size <= min_size) return false; // Area too small to split, bail out
        
    int split_point = int(random(max_size)); // generate split point 
    if(split_point < min_size) split_point = min_size; // Adjust split point so there's at least min_size in both partitions
        
    if (horizontal) { // Populate child areas
        left_child = new BSPRoom(bsp_x, bsp_y, bsp_width, split_point, min_size); 
        right_child = new BSPRoom(bsp_x, bsp_y + split_point, bsp_width, bsp_height - split_point, min_size);
    }
    else {
        left_child = new BSPRoom(bsp_x, bsp_y, split_point, bsp_height, min_size);
        right_child = new BSPRoom(bsp_x + split_point, bsp_y, bsp_width - split_point, bsp_height, min_size);
    }
    return true; // Split successful
  }

  void generateBSPRoom()
  {
    if (left_child == null) { // If leaf node, create a dungeon within the minimum size constraints
      int min_x = max(bsp_width*3/4, min_size);
      int min_y = max(bsp_height*3/4, min_size);
      room_x1 = bsp_x + ((bsp_width - min_size <= 0) ? 0 : int(random(bsp_width - min_x)));
      room_y1 = bsp_y + ((bsp_height - min_size <= 0) ? 0 : int(random(bsp_height - min_y)));
      room_x2 = room_x1 + max(int(random(bsp_width - room_x1)), min_x) - 1;
      room_y2 = room_y1 + max(int(random(bsp_height - room_y1)), min_y) - 1;
      filled = true;
    }
  }
}
