class Rat extends PhysicalObject {
  void draw() {
    if (dir == LEFT && x < 40) {
      dir = RIGHT;
    }
    if (dir == RIGHT && x > 168) {
      dir = LEFT;
    }
    
    x += dir == RIGHT ? 1 : -1;
    if (frameCount % 4 == 0) {
      frame = (frame + 1) % 2; 
    }
    super.draw();
  }
}