class Rat extends PhysicalObject {
  int holePosition;
  int target;
  int state;

  Rat() {
    animations = new int[][] {
      {0, 1},
      {2, 3, 2, 3},
      {4, 5},
      {6, 7}
    };
    animationSpeed = 4;
  }

  void scare() {
    if (state != WALKING) {
      return;
    }

    target = holePosition;
    state = SCARED;
    setAnimation(1);
  }

  void draw() {
    if (state == WALKING || state == FLEEING) {
      if (target - x == 0) {
        if (state == FLEEING) {
          state = ENTERING;
          setAnimation(2);
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

    if (framesLeft <= 0) {
      framesLeft = 4;
      aniIndex = (aniIndex + 1) % (animations[animation].length);
      if (aniIndex == 0) {
        switch (state) {
        case SCARED:
          state = FLEEING;
          setAnimation(0);
          break;
        case ENTERING:
          state = INSIDE;
          framesLeft = (int) random(300, 1200);
          x = -16;
          break;
        case INSIDE:
          state = EXITING;
          target = 96;
          setAnimation(3);
          x = holePosition;
          dir = target - x > 0 ? RIGHT : LEFT;
          break;
        case EXITING:
          state = WALKING;
        default:
          setAnimation(0);
        }
      }
      frame = animations[animation][aniIndex];
    }
    super.draw();
  }
}