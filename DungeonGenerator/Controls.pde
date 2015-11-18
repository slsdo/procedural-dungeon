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
   
  cp5 = new ControlP5(this);
  
  // Group menu items
  ControlGroup ui = cp5.addGroup("Settings").setPosition(615, 0).setWidth(185);
  ui.setBackgroundColor(color(0, 200));
  ui.setBackgroundHeight(height);
  
  // Canvas settings and more
  Textlabel textCanvas = cp5.addTextlabel("Setting").setText("Setting").setPosition(xoffset, settingoffset);
  textCanvas.setGroup(ui);
  textCanvas.setColorValue(color(200));
  
  Button buttonGenerate = cp5.addButton("Generate").setValue(0).setPosition(xoffset, settingoffset + yoffset*3).setSize(50, 30);
  buttonGenerate.setId(0);
  buttonGenerate.setGroup(ui);
  
  Button buttonRandom = cp5.addButton("Random").setValue(0).setPosition(xoffset + 55, settingoffset + yoffset*3).setSize(50, 30);
  buttonRandom.setId(1);
  buttonRandom.setGroup(ui);
  
  Button buttonStart = cp5.addButton("Save").setValue(0).setPosition(xoffset + 110, settingoffset + yoffset*3).setSize(50, 30);
  buttonStart.setId(2);
  buttonStart.setGroup(ui);
  
  Slider sliderWidth = cp5.addSlider("g_width").setRange(1, 50).setValue(g_width).setPosition(xoffset, settingoffset + yoffset*11).setSize(120, 10);
  sliderWidth.setId(3);
  sliderWidth.setGroup(ui);
  
  Slider sliderHeight = cp5.addSlider("g_height", 1, 50).setValue(g_height).setPosition(xoffset, settingoffset + yoffset*15).setSize(120, 10);
  sliderHeight.setId(4);
  sliderHeight.setGroup(ui);

  Textlabel layoutType = cp5.addTextlabel("Layout Type").setText("Layout Type").setPosition(xoffset + 1, settingoffset + yoffset*19);
  layoutType.setGroup(ui);

  DropdownList dropLayoutType = cp5.addDropdownList("Layouts").setPosition(xoffset, settingoffset + yoffset*24).setSize(70, 120).close();
  switch (g_layout) {
    case 0: dropLayoutType.getCaptionLabel().set("Basic"); break;
    case 1: dropLayoutType.getCaptionLabel().set("Cave"); break;
    case 2: dropLayoutType.getCaptionLabel().set("BSP"); break;
    case 3: dropLayoutType.getCaptionLabel().set("Build"); break;
  }
  dropLayoutType.addItem("Basic", 0);
  dropLayoutType.addItem("Cave", 1);
  dropLayoutType.addItem("BSP", 2);
  dropLayoutType.addItem("Build", 3);
  dropLayoutType.setId(21);
  dropLayoutType.setGroup(ui);
  
  Textlabel roomType = cp5.addTextlabel("Room Type").setText("Room Type").setPosition(xoffset + 86, settingoffset + yoffset*19);
  roomType.setGroup(ui);
  
  DropdownList dropRoomType = cp5.addDropdownList("Room").setPosition(xoffset + 85, settingoffset + yoffset*24).setSize(70, 120).close();
  if (g_layout == 0) {
    switch (room_type) {
      case 0: dropRoomType.getCaptionLabel().set("Scattered"); break;
      case 1: dropRoomType.getCaptionLabel().set("Sparse"); break;
      case 2: dropRoomType.getCaptionLabel().set("Dense"); break;
      case 3: dropRoomType.getCaptionLabel().set("Complex"); break;
    }
    dropRoomType.addItem("Scattered", 0);
    dropRoomType.addItem("Sparse", 1);
    dropRoomType.addItem("Dense", 2);
    dropRoomType.addItem("Complex", 3);
    dropRoomType.setId(22);
    dropRoomType.setGroup(ui);
  }
  else dropRoomType.getCaptionLabel().set("N/A");
    dropRoomType.setGroup(ui);

  Textlabel debugCanvas = cp5.addTextlabel("Debug").setText("Debug").setPosition(xoffset, settingoffset + yoffset*37);
  debugCanvas.setGroup(ui);
  debugCanvas.setColorValue(color(200));

  Toggle toggleInfo = cp5.addToggle("Info", d_show).setPosition(xoffset + 0, settingoffset + yoffset*41).setSize(10, 10);
  toggleInfo.setId(5);
  toggleInfo.setGroup(ui);
  
  Toggle toggleGrid = cp5.addToggle("Grid", g_show).setPosition(xoffset + 25, settingoffset + yoffset*41).setSize(10, 10);
  toggleGrid.setId(6);
  toggleGrid.setGroup(ui);

  Textlabel basicCanvas = cp5.addTextlabel("Basic").setText("Basic").setPosition(xoffset, settingoffset + yoffset*47);
  basicCanvas.setGroup(ui);
  basicCanvas.setColorValue(color(200));
  
  Slider sliderRmMinSize = cp5.addSlider("room_min_size").setRange(4, 36).setValue(room_min_size).setPosition(xoffset + 1, settingoffset + yoffset*50).setSize(90, 10);
  sliderRmMinSize.setId(7);
  sliderRmMinSize.setGroup(ui);

  Slider sliderRmMaxSize = cp5.addSlider("room_max_size").setRange(9, 49).setValue(room_max_size).setPosition(xoffset + 1, settingoffset + yoffset*54).setSize(90, 10);
  sliderRmMaxSize.setId(8);
  sliderRmMaxSize.setGroup(ui);
  
  Slider sliderCorrNum = cp5.addSlider("corridor_num").setRange(1, 10).setValue(corridor_num).setPosition(xoffset + 1, settingoffset + yoffset*58).setSize(90, 10);
  sliderCorrNum.setId(9);
  sliderCorrNum.setGroup(ui);

  Slider sliderPathCorrW = cp5.addSlider("corridor_weight").setRange(0, 10).setValue(corridor_weight).setPosition(xoffset + 1, settingoffset + yoffset*62).setSize(90, 10);
  sliderPathCorrW.setId(10);
  sliderPathCorrW.setGroup(ui);
  
  Slider sliderPathTurnW = cp5.addSlider("turning_weight").setRange(0, 10).setValue(turning_weight).setPosition(xoffset + 1, settingoffset + yoffset*66).setSize(90, 10);
  sliderPathTurnW.setId(11);
  sliderPathTurnW.setGroup(ui);
  
  Textlabel caCanvas = cp5.addTextlabel("Cellular Automata").setText("Cellular Automata").setPosition(xoffset, settingoffset + yoffset*70);
  caCanvas.setGroup(ui);
  caCanvas.setColorValue(color(200));
  
  Slider sliderReps = cp5.addSlider("wall_fill").setRange(10, 90).setValue(wall_fill).setPosition(xoffset + 1, settingoffset + yoffset*73).setSize(90, 10);
  sliderReps.setId(12);
  sliderReps.setGroup(ui);

  Slider sliderGenIt = cp5.addSlider("generate_iter").setRange(1, 20).setValue(generate_iter).setPosition(xoffset + 1, settingoffset + yoffset*77).setSize(90, 10);
  sliderGenIt.setId(13);
  sliderGenIt.setGroup(ui);

  Slider sliderClIt = cp5.addSlider("cleanup_iter").setRange(0, 10).setValue(cleanup_iter).setPosition(xoffset + 1, settingoffset + yoffset*81).setSize(90, 10);
  sliderClIt.setId(14);
  sliderClIt.setGroup(ui);

  Textlabel bspCanvas = cp5.addTextlabel("BSP", "BSP").setPosition(xoffset, settingoffset + yoffset*85);
  bspCanvas.setGroup(ui);
  bspCanvas.setColorValue(color(200));
  
  Slider sliderRmNum = cp5.addSlider("min_room_num").setRange(1, (g_width*g_height)/50).setValue(min_room_num).setPosition(xoffset + 1, settingoffset + yoffset*88).setSize(90, 10);
  sliderRmNum.setId(15);
  sliderRmNum.setGroup(ui);
  
  Slider sliderMinSize = cp5.addSlider("min_room_size").setRange(1, 10).setValue(min_room_size).setPosition(xoffset + 1, settingoffset + yoffset*92).setSize(90, 10);
  sliderMinSize.setId(16);
  sliderMinSize.setGroup(ui);
    
  Textlabel buildCanvas = cp5.addTextlabel("Build").setText("Build").setPosition(xoffset, settingoffset + yoffset*96);
  buildCanvas.setGroup(ui);
  buildCanvas.setColorValue(color(200));
  
  Slider sliderMaxRmw = cp5.addSlider("max_rm_w").setRange(5, 16).setValue(max_rm_w).setPosition(xoffset + 1, settingoffset + yoffset*99).setSize(90, 10);
  sliderMaxRmw.setId(17);
  sliderMaxRmw.setGroup(ui);
  
  Slider sliderMaxRmh = cp5.addSlider("max_rm_h").setRange(5, 16).setValue(max_rm_h).setPosition(xoffset + 1, settingoffset + yoffset*103).setSize(90, 10);
  sliderMaxRmh.setId(18);
  sliderMaxRmh.setGroup(ui);

  Slider sliderMaxCorrl = cp5.addSlider("max_corr_l").setRange(3, 10).setValue(max_corr_l).setPosition(xoffset + 1, settingoffset + yoffset*107).setSize(90, 10);
  sliderMaxCorrl.setId(19);
  sliderMaxCorrl.setGroup(ui);

  Slider sliderObjNum = cp5.addSlider("obj_num").setRange(1, 40).setValue(obj_num).setPosition(xoffset + 1, settingoffset + yoffset*111).setSize(90, 10);
  sliderObjNum.setId(20);
  sliderObjNum.setGroup(ui);
}

void controlEvent(ControlEvent theEvent)
{
  // Event handler
  if(theEvent.isController()) {
    switch(theEvent.getController().getId()) {
      case 0: { generate(); break; } // Generate current world
      case 1: { generate_random(); break; } // Generate random world
      case 2: { selectInput("Select a file to write to:", "fileSelected"); break; } // Opens file chooser
      case 3: { // Adjust grid width
        g_width = int(theEvent.getController().getValue());
        if (cp5.getController("Layouts").getValue() == 2 && g_width < 5) {
          g_width = 5;
          theEvent.getController().setValue(g_width);
        }
        if ((g_width*g_height)/50 > 1) cp5.getController("min_room_num").setMax((g_width*g_height)/50);
        break;
      }
      case 4: { // Adjust grid height
        g_height = int(theEvent.getController().getValue());
        if (cp5.getController("Layouts").getValue() == 2 && g_height < 5) {
          g_height = 5;
          theEvent.getController().setValue(g_height);
        }
        if ((g_width*g_height)/50 > 1) cp5.getController("min_room_num").setMax((g_width*g_height)/50);
        break;
      }
      case 5: { d_show = (theEvent.getController().getValue() == 1.0) ? true : false; world.updateParam(g_show, d_show); refresh(); break; } // Show info
      case 6: { g_show = (theEvent.getController().getValue() == 1.0) ? true : false; world.updateParam(g_show, d_show); refresh(); break; } // Show grid
      case 7: { room_min_size = int(theEvent.getController().getValue()); break; }
      case 8: { room_max_size = int(theEvent.getController().getValue()); break; }
      case 9: { corridor_num = int(theEvent.getController().getValue()); break; }
      case 10: { corridor_weight = int(theEvent.getController().getValue()); break; } 
      case 11: { turning_weight = int(theEvent.getController().getValue()); break; }
      case 12: { wall_fill = int(theEvent.getController().getValue()); break; }
      case 13: { generate_iter = int(theEvent.getController().getValue()); break; }
      case 14: { cleanup_iter = int(theEvent.getController().getValue()); break; }
      case 15: { min_room_num = int(theEvent.getController().getValue()); break; }
      case 16: { min_room_size = int(theEvent.getController().getValue()); break; }
      case 17: { max_rm_w = int(theEvent.getController().getValue()); break; }
      case 18: { max_rm_h = int(theEvent.getController().getValue()); break; }
      case 19: { max_corr_l = int(theEvent.getController().getValue()); break; }
      case 20: { obj_num = int(theEvent.getController().getValue()); break; }
      case 21: {
        g_layout = int(theEvent.getController().getValue());        
        if (g_layout == 0) {
          switch (room_type) {
            case 0: cp5.getController("Room").setLabel("Scattered"); break;
            case 1: cp5.getController("Room").setLabel("Sparse"); break;
            case 2: cp5.getController("Room").setLabel("Dense"); break;
            case 3: cp5.getController("Room").setLabel("Complex"); break;
          }
          cp5.getController("Room").unlock();
        } //<>//
        else {
          cp5.getController("Room").lock();
          cp5.getController("Room").setLabel("N/A");
        }
        if (g_layout == 2) {
          if (g_width < 5) {
            g_width = 5;
            cp5.getController("g_width").setValue(g_width);
          }
          if (g_height < 5) {
            g_height = 5;
            cp5.getController("g_width").setValue(g_height);
          }
        }
        break;
      }
      case 22: { room_type = int(theEvent.getController().getValue()); break; } // Choose room type
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