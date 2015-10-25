class Rat extends PhysicalObject {
  int target;
  int state;
  int animation = 0;
  int aniIndex = 0;
  int[][] animations = {
    {0, 1}, 
    {2, 3}, 
    {4, 5}, 
    {6, 7}
  };

  void draw() {
    if (state == WALKING || state == FLEEING) {
      if (target - x == 0) {
        if (state == FLEEING) {
          state = ENTERING;
        }
        target = (int)random(40, 168);
      } else if (target - x > 0) {
        dir = RIGHT;
      } else {
        dir = LEFT;
      }
      x += dir == RIGHT ? 1 : -1;
    }
    framesLeft--;

    switch (state) {
      case SCARED:
        animation = 1;
        break;
      case ENTERING:
        animation = 2;
        break;
      case EXITING:
        animation = 3;
        break;
      default:
        animation = 0;
        break;
    }
    if (state == SCARED) {
      animation = 1;
    }

    if (framesLeft <= 0) {
      framesLeft = 4;
      aniIndex = (aniIndex + 1) % 2;
      if (state == SCARED && aniIndex == 0) {
        state = FLEEING;
      }
      frame = animations[animation][aniIndex];
    }
    super.draw();
  }
}