class Rat extends PhysicalObject {
  int target;
  int state;
  int animation = 0;
  int aniIndex = 0;
  int[][] animations = {
    {0, 1},
    {2, 3}
  };
  
  void draw() {
    if (dir == LEFT && x < 40) {
      dir = RIGHT;
    }
    if (dir == RIGHT && x > 168) {
      dir = LEFT;
    }
    
    x += dir == RIGHT ? 1 : -1;
    framesLeft--;
    
    if (state == SCARED) {
      animation = 1;
    }
    
    if (framesLeft <= 0) {
      framesLeft = 4;
      aniIndex = (aniIndex + 1) % 2;
      frame = animations[animation][aniIndex];
    }
    super.draw();
  }
}