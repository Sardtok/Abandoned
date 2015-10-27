class Baby extends PhysicalObject {
  Baby() {
    animations = new int[][] {
      { 0, 1, 2, 0, 3, 4 }, 
      { 5, 6 }
    };
  }

  float pX;
  boolean isMoving = false;
  Platform currentFloor;
  Stairway currentStairs;

  void walkStairs(float movement) {
    if (currentStairs == null) {
      return;
    }

    y += movement;
    x = currentStairs.getX(y);
    if (y == currentStairs.top.y - img.height / 2) {
      state = FLOOR;
      currentFloor = currentStairs.top;
      currentStairs = null;
    } else if (y == currentStairs.bottom.y - img.height / 2) {
      state = FLOOR;
      currentFloor = currentStairs.bottom;
      currentStairs = null;
    }
  }

  void walkStairs() {
    boolean up = false;
    boolean down = false;

    if ((buttons & 4) != 0) {
      up = true;
    }
    if ((buttons & 8) != 0) {
      down = true;
    }
    if ((buttons & 1) != 0 && state == STAIRS) {
      if ((buttons & 1) != 0) {
        up = true;
      }
      if ((buttons & 2) != 0) {
        down = true;
      }
    }
    if ((buttons & 2) != 0 && state == STAIRS) {
      if ((buttons & 1) != 0) {
        down = true;
      }
      if ((buttons & 2) != 0) {
        up = true;
      }
    }

    if (up && !down) {
      if (state != STAIRS) {
        for (Stairway stairs : currentFloor.up) {
          if (stairs.climb(x)) {
            state = STAIRS;
            x = stairs.botX;
            currentStairs = stairs;
          }
        }
      }
      
      walkStairs(-0.25);
    } else if (down && !up) {
      if (state != STAIRS) {
        for (Stairway stairs : currentFloor.down) {
          if (stairs.descend(x)) {
            state = STAIRS;
            x = stairs.topX;
            currentStairs = stairs;
          }
        }
      }
      
      walkStairs(0.25);
    }
  }

  void smackRats() {
    for (Rat r : rats) {
      float distance = x - r.x;
      if (abs(y - r.y) < 4 &&((dir == LEFT && distance < 16 && distance > 8)
        || (dir == RIGHT && distance > -16 && distance < -8))) {
        if (r.scare()) {
          score += 100;
        }
      }
    }
  }

  void animationComplete() {
    state &= ~SLAM;
    setAnimation(0);
  }

  void draw() {
    pX = x;
    if ((buttons & 16) != 0 && animation == 0) {
      state |= SLAM;
      setAnimation(1);
    } else if (animation == 0 && buttons == 0) {
      setAnimation(0);
    }

    if (animation == 1) {
      smackRats();
    }

    if ((buttons & 1) != 0 && state == FLOOR) {
      if ((buttons & 2) == 0) {
        dir = LEFT;
        x -= 0.5;
      }
    } else if ((buttons & 2) != 0 && state == FLOOR) {
      dir = RIGHT;
      x += 0.5;
    }

    if ((buttons & 12) != 0 || state == STAIRS) {
      walkStairs();
    }

    if (x < 8 || x > 172) {
      x = pX;
    }

    if (state == FLOOR && pX == x) {
      setAnimation(0);
    }
    super.draw();
  }
}