class Baby extends PhysicalObject {
  Baby() {
    animations = new int[][] {
      { 0, 1, 2, 0, 3, 4 }, 
      { 5, 6 }, 
      { 9, 10, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8 }, 
      { 11, 12, 13, 14 }
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
    x = currentStairs.getX(y + img.height / 2);
    if (y <= currentStairs.top.y - img.height / 2) {
      state = FLOOR;
      currentFloor = currentStairs.top;
      currentStairs = null;
    } else if (y >= currentStairs.bottom.y - img.height / 2) {
      state = FLOOR;
      currentFloor = currentStairs.bottom;
      currentStairs = null;
    }
  }

  void walkStairs() {
    if (state != FLOOR && state != STAIRS) {
      return;
    }
    
    boolean up = false;
    boolean down = false;

    if ((buttons & 4) != 0) {
      up = true;
    }
    if ((buttons & 8) != 0) {
      down = true;
    }
    if ((buttons & 1) != 0 && state == STAIRS) {
      up |= currentStairs.topX < currentStairs.botX;
      down |= currentStairs.topX > currentStairs.botX;
    }
    if ((buttons & 2) != 0 && state == STAIRS) {
      up |= currentStairs.topX > currentStairs.botX;
      down |= currentStairs.topX < currentStairs.botX;
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

  void smackRat(Rat r) {
    if (r == null) {
      return;
    }
    
    float distance = x - r.x;

    if ((y - r.y < 2 && y - r.y > -8) && ((dir == LEFT && distance < 16 && distance > 8)
      || (dir == RIGHT && distance > -16 && distance < -8))) {
      r.scare();
    }
  }

  void scare() {
    if (state == SCARED) {
      return;
    }

    state = SCARED;
    setAnimation(2);
  }

  void animationComplete() {
    state &= ~SLAM;
    if (state == SCARED) {
      startGame();
    } else if (state == ENTERING) {
      int p = score;
      level++;
      startLevel();
      score = p;
      score(900 + level * 100);
      dir = RIGHT;
    }
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
      if (state == STAIRS) {
        smackRat(currentStairs.top.rat);
        smackRat(currentStairs.bottom.rat);
      } else {
        smackRat(currentFloor.rat);
      }
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

    if (pX != x) {
      dir = x < pX ? LEFT : RIGHT;
    }

    if (x < 8 || x > 172) {
      x = pX;
    }

    if (x <= 54 && y <= 32 && state == FLOOR) {
      state = ENTERING;
      setAnimation(3);
    }

    if (state == FLOOR && pX == x) {
      setAnimation(0);
    }
    super.draw();
  }
}