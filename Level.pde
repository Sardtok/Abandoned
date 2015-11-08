class Level {
  ArrayList<Platform> floors = new ArrayList<Platform>();
  PGraphics fg = createGraphics(192, 168);
  
  void drawBG() {
    for (Platform floor : floors) {
      floor.draw();
    }
  }
  
  void drawFG() {
    image(fg, 0, 0);
  }
  
  void renderForeground() {
    fg.beginDraw();
    fg.clear();
    fg.noSmooth();
    fg.stroke(basePalette[3]);
    fg.strokeWeight(2);
    fg.strokeCap(SQUARE);
    
    for (Platform floor : floors) {
      fg.line(floor.left, floor.y + 1, floor.right, floor.y + 1);
      if (floor.left > 32) {
        fg.line(floor.left - 1, floor.y + 2, floor.left - 1, floor.y - 8);
      }
      fg.line(floor.right + 1, floor.y + 2, floor.right + 1, floor.y - 8);
      
      for (Stairway stairs : floor.up) {
        fg.line(stairs.botX, stairs.bottom.y, stairs.topX, stairs.top.y);
      }
    }
    
    fg.endDraw();
  }
}