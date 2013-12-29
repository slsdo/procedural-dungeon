void renderInfo()
{
  // Render info
  if (d_show) {
    fill(230);
    text("Press 'space' to generate", 15, 20);
    fill(0);
    stroke(150);
    rect(15, 30, 10, 10);
    fill(230);
    text("Empty", 30, 40);
    fill(255);
    stroke(150);
    rect(15, 45, 10, 10);
    fill(230);
    text("Floor", 30, 55);
    fill(200);
    stroke(150);
    rect(15, 60, 10, 10);
    fill(230);
    text("Wall", 30, 70);
    fill(0, 102, 153);
    stroke(150);
    rect(15, 75, 10, 10);
    fill(230);
    text("Door", 30, 85);
    fill(64, 102, 104);
    stroke(150);
    rect(15, 90, 10, 10);
    fill(230);
    text("BSP node border", 30, 100);
  }  
}

void renderGrid()
{
  // Render grid
  for (int j = 0; j < world.grid_height; j++) {
    for (int i = 0; i < world.grid_width; i++) {
      renderGridCell(i, j);
    }
  }
}

void renderGridCell(int x, int y)
{
  // Render grid cell content
  switch (world.grid[x][y]) {
    case 0: // Empty
      fill(0);
      if (world.show_grid) stroke(150);
      rect(x*10, y*10, 10, 10);
      break;
    case 1: // Floor
      fill(255);
      if (world.show_grid) stroke(150);
      rect(x*10, y*10, 10, 10);
      break;
    case 2: // Wall
      if (world.debug) fill(200);
      else fill(255);
      if (world.show_grid) stroke(150);
      rect(x*10, y*10, 10, 10);
      break;
    case 3: // Door
      if (world.debug) fill(0, 102, 153);
      else fill(255);
      if (world.show_grid) stroke(150);
      rect(x*10, y*10, 10, 10);
      break;
    case 4: // Corridor
      fill(255);
      if (world.show_grid) stroke(150);
      rect(x*10, y*10, 10, 10);
      break;
    case 5: // BSP border
      if (world.debug) fill(64, 102, 104);
      else fill(0);
      if (world.show_grid) stroke(150);
      rect(x*10, y*10, 10, 10);
      break;
  }
}
