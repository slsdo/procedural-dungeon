// Global variables
Cave map = new Cave(300, 200, 10);

// Setup the Processing Canvas
void setup() {
  size(300, 200);
  noLoop();
}

// Main draw loop
void draw() {
  // Fill canvas black
  background(0);
  noStroke();

  map.generateCave(100, 500, 0.5, "DEFAULT", 0);
  map.drawGrid();
}

void keyPressed() {
  if (key == ENTER || key == RETURN) {
	map.generateCave(100, 500, 0.5, "DEFAULT", 0);
	redraw();
  }
}

class vec2 {
  int x;
  int y;

  vec2() { x = 0; y = 0; }
  vec2(int ix, int iy) { x = ix; y = iy; }
}

class Grid {
  int gridWidth; // Grid width
  int gridHeight; // Grid height
  int cellSize; // Grid cell size
  int[][] grid; // Stores the gridcells

  Grid(int width, int height, int size) {
	gridWidth = width/size;
	gridHeight = height/size;
	cellSize = size;

	grid = new int[gridWidth][gridHeight];

	reset();
  }

  // Reset grid
  void reset() {
	for (int j = 0; j < gridHeight; j++) {
	  for (int i = 0; i < gridWidth; i++) {
		grid[i][j] = 0;
	  }
	}
  }

  // Draw current cell
  void drawCell(int x, int y) {
	switch (grid[x][y]) {
	  case 0:
		fill(0);
		rect(x*cellSize, y*cellSize, cellSize, cellSize);
		break;
	  case 1:
		fill(255);
		rect(x*cellSize, y*cellSize, cellSize, cellSize);
		break;
	  case 2:
		fill(255, 0, 0);
		rect(x*cellSize, y*cellSize, cellSize, cellSize);
		break;
	  case 3:
		fill(0, 0, 255);
		rect(x*cellSize, y*cellSize, cellSize, cellSize);
		break;
	}
  }

  // Draw current grid
  void drawGrid() {
	for (int j = 0; j < gridHeight; j++) {
	  for (int i = 0; i < gridWidth; i++) {
		drawCell(i, j);
	  }
	}
  }

  // Draw coordinate lines
  void drawGridLine() {
	for (int i = 0; i < gridWidth; i++) {
	  stroke(255, 0, 0);
	  line(i*cellSize, 0, i*cellSize, height);
	}
	for (int j = 0; j < gridHeight; j++) {
	  stroke(255, 0, 0);
	  line(0, j*cellSize, width, j*cellSize);
	}
  }
}

class Cave extends Grid {
  // Cave information
  int cellCount;
  int[] xOffset = { 1, 0, -1, 0 };
  int[] yOffset = { 0, -1, 0, 1 };

  Cave(int width, int height, int size) {
	super(width, height, size);
  }

  // Based on the Cave Generation algorithm created by Chevy Johnston
  // http://forums.tigsource.com/index.php?topic=5174
  void generateCave(int minSize, int maxSize, float turnRatio, String type, int iter) {
	// Clear the current map
	reset();
	cellCount = 1;
	
	// Set starting cell
	vec2 start = new vec2(int(gridWidth*0.5), int(gridHeight*0.5));
	ArrayList cList = new ArrayList();
	cList.add(start);
	grid[start.x][start.y] = 2;
	
	growPaths(cList, minSize, maxSize, turnRatio, type, iter);

	// Use recursive check to minimize the map size
	if (cellCount < minSize) generateCave(minSize, maxSize, turnRatio, type, iter + 1);
  }
  
  void growPaths(ArrayList cList, int minSize, int maxSize, float turnRatio, String type, int iter) {
	// Intialize some variables
	
	vec2 cell = new vec2();
	int openPaths = 1;
	int[] orderList = { 0, 1, 2, 3 };
	int adjacentNum = 2;

	orderList = shuffle(orderList); // Randomize direction
	
	// For each cell on the list
	for (int i = 0; i < cellCount; i++) {
	  // Get the Cell we are working with
	  cell = (vec2) cList.get(i);

	  // Decide how many adjacent cells to create around this cell
	  adjacentNum = adjacentCells(openPaths, type);

	  // Shuffle the order list
	  if (random(1) < turnRatio) orderList = shuffle(orderList);

	  // For each adjacent position (dealt with in the order as defined by orderList)
	  if (adjacentNum > 0) {
		for (int j = 0; j < 4; j++) {
		  vec2 adj = new vec2(cell.x + xOffset[orderList[j]], cell.y + yOffset[orderList[j]]);

		  if (adj.x >= 0 && adj.x < gridWidth && adj.y >= 0 && adj.y < gridHeight && grid[adj.x][adj.y] == 0) {
			// Add and fill the adjacent cell
			cList.add(adj);
			grid[adj.x][adj.y] = 1;
			openPaths++;
			cellCount++;
			adjacentNum--;

			// Break when we can't create any more adjacent cells
			if (adjacentNum == 0) break;
		  }
		  if (cellCount == maxSize) break;
		}
		if (cellCount == maxSize) break;
	  }
	  openPaths--;
	}
	grid[cell.x][cell.y] = 3;
  }

  // Return number of adjacent cells
  int adjacentCells(int openPaths, String type) {
	if (type == "THIN") {
	  // This is one of multiple open paths
	  if (openPaths > 1) {
		switch (int(random(1)*7)) {
		  case 0: return 0; 
		  case 1: return 2; 
		  default: return 1;
		}
	  }
	  // This is the last open path
	  else return 1;
	}
	else if (type == "THIN") {
	  // This is one of multiple open paths
	  if (openPaths > 1) {
		switch (int(random(1)*4)) {
		  case 0: return 1;
		  case 1: return 2;
		  case 2: return 3;
		  case 3: return 4;
		  default: return 1;
		}
	  }
	  // This is the last open path
	  else {
		switch (int(random(1)*3)) {
		  case 0: return 1;
		  default: return 2;
		}
	  }
	}
	else {
	  // This is one of multiple open paths
	  if (openPaths > 1) {
		switch (int(random(1)*4)) {
		  case 0: return 0;
		  case 1: return 1;
		  case 2: return 1;
		  case 3: return 2;
		  default: return 1;
		}
	  }
	  // This is the last open path
	  else {
		switch (int(random(1)*4)) {
		  case 0: return 1;
		  case 1: return 1;
		  case 2: return 1;
		  case 3: return 2;
		  default: return 1;
		}
	  }
	}
  }

  // Shuffle array
  int[] shuffle(int[] a) {
	for (int i = a.length - 1; i > 0; i--) {
	  int rand = int(random(i));
	  int tmp = a[i];
	  a[i] = a[rand];
	  a[rand] = tmp;
	}
	return a;
  }
}