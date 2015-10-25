class Baby extends PhysicalObject {
  
  int aniIndex = 0;
  int[] walkAnimation = { 0, 1, 2, 0, 3, 4 };
  
  void draw() {
    if (frameCount % 8 == 0) {
      aniIndex = (aniIndex + 1) % walkAnimation.length;
      frame = walkAnimation[aniIndex];
    }
    if ((buttons & 1) != 0) {
      if ((buttons & 2) == 0) {
        dir = LEFT;
      }
    } else if ((buttons & 2) != 0) {
      dir = RIGHT;
    }
    super.draw();
  }
}