/* Procedural Dungeon Generator
   www.futuredatalab.com/proceduraldungeon/
   
   Compatible with Processing 3.0.1 and ControlP5 2.2.5 */

import controlP5.*;

World world;
ControlP5 cp5;

void setup() {
  size(800, 600);
  noSmooth();
  world = new World();
  refresh();
  controlUI();
}

void draw() {
}

void keyPressed() {
  if (key == ' ') {
    generate();
  }
}