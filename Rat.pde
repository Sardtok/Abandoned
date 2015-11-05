class Rat extends PhysicalObject {
  int target;
  int count;
  float speed;
  Platform floor;

  Rat(Platform floor) {
    animations = new int[][] {
      {0, 1}, 
      {2, 3, 2, 3}, 
      {4, 5}, 
      {6, 7}
    };
    speed = 1.0;
    animationSpeed = 4;
    this.floor = floor;
    y = floor.y - 4;
  }

  void scare() {
    if (state != WALKING) {
      return;
    }

    score += speed * 100;
    speed = min(2, speed + 0.25);
    target = floor.hole;
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
      count = 0;
      state = INSIDE;
      setAnimation(0);
      framesLeft = (int) random(300, 1200);
      x = -16;
      break;
    case INSIDE:
      state = EXITING;
      target = 96;
      setAnimation(3);
      x = floor.hole;
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
      if (abs(target - x) < speed) {
        count++;
        if (state == FLEEING) {
          x = target;
          state = ENTERING;
          setAnimation(2);
        }
        if (count >= 10 && random(1.0) > 0.75) {
          count = 0;
          state = FLEEING;
          target = floor.hole;
        } else if (dir == LEFT) {
          target = (int) min(168, x + random(32, 128));
        } else {
          target = (int) max(40, x - random(32, 128));
        }
      } else if (target - x > 0) {
        dir = RIGHT;
      } else {
        dir = LEFT;
      }
      x += dir == RIGHT ? speed : -speed;
    }

    if (state == WALKING && abs(baby.x - x) < 8 && baby.y - y > -8 && baby.y - y <= 4) {
      baby.scare();
    }

    super.draw();
  }
}