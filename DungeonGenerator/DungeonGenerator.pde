/* Procedural Dungeon Generator
   - by Future Data Lab | www.futuredatalab.com */

import controlP5.*;

World world;
ControlP5 controlP5;

void setup() {
  size(800, 600);
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

