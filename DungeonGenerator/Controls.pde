// Parameters
public int g_width = 40; // Grid width
public int g_height = 30; // Grid height
public int g_layout = 0; // Layout type
public boolean g_show = true; // Display grid
public boolean d_show = true; // Display information
// Basic
public int room_min_size = 9;
public int room_max_size = 16;
public int corridor_num = 2;
public int corridor_weight = 4;
public int turning_weight = 4;
public int room_type = 0; // Room type
// CA
public int wall_fill = 40; // Openess
public int generate_iter = 4; // Cycles
public int cleanup_iter = 3; // Cycles
// BSP
public int min_room_num = (g_width*g_height)/100; // Minimum number of rooms
public int min_room_size = 5; // Min room size
// Build
public int max_rm_w = 8; // Max room width
public int max_rm_h = 8; // Max room height
public int max_corr_l = 6; // Max corridor length
public int obj_num = 10; // Number of objects

void controlUI()
{
  // Position offsets
  int xoffset = 10;
  int yoffset = 5;
  int settingoffset = 10;
   
  controlP5 = new ControlP5(this);
  
  // Group menu items
  ControlGroup ui = controlP5.addGroup("Settings", 615, 0, 185);
  ui.setBackgroundColor(color(0, 200));
  ui.setBackgroundHeight(height);
  
  // Canvas settings and more
  Textlabel textCanvas = controlP5.addTextlabel("Setting", "Setting", xoffset, settingoffset);
  textCanvas.setGroup(ui);
  textCanvas.setColorValue(color(200));
  
  Button buttonGenerate = controlP5.addButton("Generate", 0, xoffset, settingoffset + yoffset*3, 50, 30);
  buttonGenerate.setId(0);
  buttonGenerate.setGroup(ui);
  
  Button buttonRandom = controlP5.addButton("Random", 0, xoffset + 55, settingoffset + yoffset*3, 50, 30);
  buttonRandom.setId(1);
  buttonRandom.setGroup(ui);
  
  Button buttonStart = controlP5.addButton("Save", 0, xoffset + 110, settingoffset + yoffset*3, 50, 30);
  buttonStart.setId(2);
  buttonStart.setGroup(ui);
  
  Slider sliderWidth = controlP5.addSlider("g_width", 1, 50, g_width, xoffset, settingoffset + yoffset*11, 120, 10);
  sliderWidth.setId(3);
  sliderWidth.setGroup(ui);
  
  Slider sliderHeight = controlP5.addSlider("g_height", 1, 50, g_height, xoffset, settingoffset + yoffset*15, 120, 10);
  sliderHeight.setId(4);
  sliderHeight.setGroup(ui);

  Textlabel layoutType = controlP5.addTextlabel("Layout Type", "Layout Type", xoffset + 1, settingoffset + yoffset*19);
  layoutType.setGroup(ui);

  DropdownList dropLayoutType = controlP5.addDropdownList("Layouts", xoffset, settingoffset + yoffset*24, 70, 120);
  switch (g_layout) {
    case 0: dropLayoutType.captionLabel().set("Basic"); break;
    case 1: dropLayoutType.captionLabel().set("Cave"); break;
    case 2:  dropLayoutType.captionLabel().set("BSP"); break;
    case 3:  dropLayoutType.captionLabel().set("Build"); break;
  }
  dropLayoutType.addItem("Basic", 0);
  dropLayoutType.addItem("Cave", 1);
  dropLayoutType.addItem("BSP", 2);
  dropLayoutType.addItem("Build", 3);
  dropLayoutType.setGroup(ui);
  
  Textlabel roomType = controlP5.addTextlabel("Room Type", "Room Type", xoffset + 86, settingoffset + yoffset*19);
  roomType.setGroup(ui);
  
  DropdownList dropRoomType = controlP5.addDropdownList("Room", xoffset + 85, settingoffset + yoffset*24, 70, 120);
  if (g_layout == 0) {
    switch (room_type) {
      case 0: dropRoomType.captionLabel().set("Scattered"); break;
      case 1: dropRoomType.captionLabel().set("Sparse"); break;
      case 2: dropRoomType.captionLabel().set("Dense"); break;
      case 3: dropRoomType.captionLabel().set("Complex"); break;
    }
    dropRoomType.addItem("Scattered", 0);
    dropRoomType.addItem("Sparse", 1);
    dropRoomType.addItem("Dense", 2);
    dropRoomType.addItem("Complex", 3);
    dropRoomType.setGroup(ui);
  }
  else dropRoomType.captionLabel().set("N/A");
    dropRoomType.setGroup(ui);

  Textlabel debugCanvas = controlP5.addTextlabel("Debug", "Debug", xoffset, settingoffset + yoffset*37);
  debugCanvas.setGroup(ui);
  debugCanvas.setColorValue(color(200));

  Toggle toggleInfo = controlP5.addToggle("Info", d_show, xoffset + 0, settingoffset + yoffset*41, 10, 10);
  toggleInfo.setId(5);
  toggleInfo.setGroup(ui);
  
  Toggle toggleGrid = controlP5.addToggle("Grid", g_show, xoffset + 25, settingoffset + yoffset*41, 10, 10);
  toggleGrid.setId(6);
  toggleGrid.setGroup(ui);

  Textlabel basicCanvas = controlP5.addTextlabel("Basic", "Basic", xoffset, settingoffset + yoffset*47);
  basicCanvas.setGroup(ui);
  basicCanvas.setColorValue(color(200));
  
  Slider sliderRmMinSize = controlP5.addSlider("room_min_size", 4, 36, room_min_size, xoffset + 1, settingoffset + yoffset*50, 90, 10);
  sliderRmMinSize.setId(7);
  sliderRmMinSize.setGroup(ui);

  Slider sliderRmMaxSize = controlP5.addSlider("room_max_size", 9, 49, room_max_size, xoffset + 1, settingoffset + yoffset*54, 90, 10);
  sliderRmMaxSize.setId(8);
  sliderRmMaxSize.setGroup(ui);
  
  Slider sliderCorrNum = controlP5.addSlider("corridor_num", 1, 10, corridor_num, xoffset + 1, settingoffset + yoffset*58, 90, 10);
  sliderCorrNum.setId(9);
  sliderCorrNum.setGroup(ui);

  Slider sliderPathCorrW = controlP5.addSlider("corridor_weight", 0, 10, corridor_weight, xoffset + 1, settingoffset + yoffset*62, 90, 10);
  sliderPathCorrW.setId(10);
  sliderPathCorrW.setGroup(ui);
  
  Slider sliderPathTurnW = controlP5.addSlider("turning_weight", 0, 10, turning_weight, xoffset + 1, settingoffset + yoffset*66, 90, 10);
  sliderPathTurnW.setId(11);
  sliderPathTurnW.setGroup(ui);
  
  Textlabel caCanvas = controlP5.addTextlabel("Cellular Automata", "Cellular Automata", xoffset, settingoffset + yoffset*70);
  caCanvas.setGroup(ui);
  caCanvas.setColorValue(color(200));
  
  Slider sliderReps = controlP5.addSlider("wall_fill", 10, 90, wall_fill, xoffset + 1, settingoffset + yoffset*73, 90, 10);
  sliderReps.setId(12);
  sliderReps.setGroup(ui);

  Slider sliderGenIt = controlP5.addSlider("generate_iter", 1, 20, generate_iter, xoffset + 1, settingoffset + yoffset*77, 90, 10);
  sliderGenIt.setId(13);
  sliderGenIt.setGroup(ui);

  Slider sliderClIt = controlP5.addSlider("cleanup_iter", 0, 10, cleanup_iter, xoffset + 1, settingoffset + yoffset*81, 90, 10);
  sliderClIt.setId(14);
  sliderClIt.setGroup(ui);

  Textlabel bspCanvas = controlP5.addTextlabel("BSP", "BSP", xoffset, settingoffset + yoffset*85);
  bspCanvas.setGroup(ui);
  bspCanvas.setColorValue(color(200));
  
  Slider sliderRmNum = controlP5.addSlider("min_room_num", 1, (g_width*g_height)/50, min_room_num, xoffset + 1, settingoffset + yoffset*88, 90, 10);
  sliderRmNum.setId(15);
  sliderRmNum.setGroup(ui);
  
  Slider sliderMinSize = controlP5.addSlider("min_room_size", 1, 10, min_room_size, xoffset + 1, settingoffset + yoffset*92, 90, 10);
  sliderMinSize.setId(16);
  sliderMinSize.setGroup(ui);
    
  Textlabel buildCanvas = controlP5.addTextlabel("Build", "Build", xoffset, settingoffset + yoffset*96);
  buildCanvas.setGroup(ui);
  buildCanvas.setColorValue(color(200));
  
  Slider sliderMaxRmw = controlP5.addSlider("max_rm_w", 5, 16, max_rm_w, xoffset + 1, settingoffset + yoffset*99, 90, 10);
  sliderMaxRmw.setId(17);
  sliderMaxRmw.setGroup(ui);
  
  Slider sliderMaxRmh = controlP5.addSlider("max_rm_h", 5, 16, max_rm_h, xoffset + 1, settingoffset + yoffset*103, 90, 10);
  sliderMaxRmh.setId(18);
  sliderMaxRmh.setGroup(ui);

  Slider sliderMaxCorrl = controlP5.addSlider("max_corr_l", 3, 10, max_corr_l, xoffset + 1, settingoffset + yoffset*107, 90, 10);
  sliderMaxCorrl.setId(19);
  sliderMaxCorrl.setGroup(ui);

  Slider sliderObjNum = controlP5.addSlider("obj_num", 1, 40, obj_num, xoffset + 1, settingoffset + yoffset*111, 90, 10);
  sliderObjNum.setId(20);
  sliderObjNum.setGroup(ui);
}

void controlEvent(ControlEvent theEvent)
{
  // Event handler
  if (theEvent.isGroup()) {
    if (theEvent.group().name() == "Layouts") {
      g_layout = int(theEvent.group().value());
      if (g_layout == 0) {
        switch (room_type) {
          case 0: controlP5.group("Room").setLabel("Scattered"); break;
          case 1: controlP5.group("Room").setLabel("Sparse"); break;
          case 2: controlP5.group("Room").setLabel("Dense"); break;
          case 3: controlP5.group("Room").setLabel("Complex"); break;
        }
        controlP5.group("Room").enableCollapse();
      }
      else {
        controlP5.group("Room").disableCollapse();
        controlP5.group("Room").setLabel("N/A");
      }  
    } // Choose layout
    else if (theEvent.group().name() == "Room") room_type = int(theEvent.group().value()); // Choose room type
  }
  else if(theEvent.isController()) {
    switch(theEvent.controller().id()) {
      case 0: { generate(); break; } // Generate current world
      case 1: { generate_random(); break; } // Generate random world
      case 2: { selectInput("Select a file to write to:", "fileSelected"); break; } // Opens file chooser
      case 3: { g_width = int(theEvent.controller().value()); controlP5.controller("min_room_num").setMax((g_width*g_height)/50); break; } // Adjust grid width
      case 4: { g_height = int(theEvent.controller().value()); controlP5.controller("min_room_num").setMax((g_width*g_height)/50); break; } // Adjust grid height
      case 5: { d_show = (theEvent.controller().value() == 1.0) ? true : false; world.updateParam(g_show, d_show); refresh(); break; } // Show info
      case 6: { g_show = (theEvent.controller().value() == 1.0) ? true : false; world.updateParam(g_show, d_show); refresh(); break; } // Show grid
      case 7: { room_min_size = int(theEvent.controller().value()); break; }
      case 8: { room_max_size = int(theEvent.controller().value()); break; }
      case 9: { corridor_num = int(theEvent.controller().value()); break; }
      case 10: { corridor_weight = int(theEvent.controller().value()); break; } 
      case 11: { turning_weight = int(theEvent.controller().value()); break; }
      case 12: { wall_fill = int(theEvent.controller().value()); break; }
      case 13: { generate_iter = int(theEvent.controller().value()); break; }
      case 14: { cleanup_iter = int(theEvent.controller().value()); break; }
      case 15: { min_room_num = int(theEvent.controller().value()); break; }
      case 16: { min_room_size = int(theEvent.controller().value()); break; }
      case 17: { max_rm_w = int(theEvent.controller().value()); break; }
      case 18: { max_rm_h = int(theEvent.controller().value()); break; }
      case 19: { max_corr_l = int(theEvent.controller().value()); break; }
      case 20: { obj_num = int(theEvent.controller().value()); break; }
    }
  }
}

void generate()
{
  world.generateWorld(g_layout + 1, g_width, g_height);
  refresh(); // Refresh screen
}

void generate_random()
{
  world.randomWorld(); // Generate random world
  refresh(); // Refresh screen
}

void refresh()
{
  // Position grid in center
  background(51);
  pushMatrix(); 
  translate(width*0.5 - g_width*0.5*10 - 185*0.5, height*0.5 - g_height*0.5*10);
  renderGrid();
  popMatrix();
  renderInfo();
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  }
  else {
    println("User selected " + selection.getAbsolutePath());
    PrintWriter output;
    output = createWriter(selection + ".txt");
    for (int j = 0; j < world.grid_height; j++) {
      for (int i = 0; i < world.grid_width; i++) {
        output.print(world.grid[i][j] + " ");
      }
      output.print("\n");
    }
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file 
  }
}