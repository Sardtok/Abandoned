class Rat extends PhysicalObject {
  int holePosition;
  int target;

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

  void animationComplete() {
    switch (state) {
    case SCARED:
      state = FLEEING;
      setAnimation(0);
      break;
    case ENTERING:
      state = INSIDE;
      setAnimation(0);
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
    
    super.draw();
  }
}