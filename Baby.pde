class Baby extends PhysicalObject {
  Baby() {
    animations = new int[][] {
      { 0, 1, 2, 0, 3, 4 }, 
      { 5, 6 }
    };
  }

  boolean isMoving = false;
  int currentFloor = 3;

  void walkStairs() {
    boolean up = false;
    boolean down = false;

    if ((buttons & 4) != 0) {
      up = true;
    }
    if ((buttons & 8) != 0) {
      down = true;
    }
    if (currentFloor % 2 == 0) {
      if ((buttons & 1) != 0) {
        up = true;
      }
      if ((buttons & 2) != 0) {
        down = true;
      }
    } else {
      if ((buttons & 1) != 0) {
        down = true;
      }
      if ((buttons & 2) != 0) {
        up = true;
      }
    }

    if (up && !down) {
      if (state != STAIRS) {
        if (abs(stairsUp[currentFloor] - x) < 4) {
          state = STAIRS;
          y -= 0.25;
        }
      } else {
        y -= 0.25;
        if (y == floorPositions[currentFloor - 1] - img.height / 2) {
          state = FLOOR;
          currentFloor--;
        }
      }
      dir = currentFloor % 2 == 0 ? LEFT : RIGHT;
    } else if (down && !up) {
      if (state != STAIRS) {
        if (abs(stairsDown[currentFloor] - x) < 4) {
          currentFloor++;
          state = STAIRS;
          y += 0.25;
        }
      } else {
        y += 0.25;
        if (y == floorPositions[currentFloor] - img.height / 2) {
          state = FLOOR;
        }
      }
      dir = currentFloor % 2 == 0 ? RIGHT : LEFT;
    }

    if (state != STAIRS) {
      return;
    }

    float along = (float)(y - floorPositions[currentFloor]) / (floorPositions[currentFloor - 1] - floorPositions[currentFloor]);
    if (currentFloor % 2 == 0) {
      x = max(stairsDown[currentFloor - 1], stairsUp[currentFloor]) - (int)(along * abs(stairsDown[currentFloor - 1] - stairsUp[currentFloor])) + 5;
    } else {
      x = min(stairsDown[currentFloor - 1], stairsUp[currentFloor]) + (int)(along * abs(stairsDown[currentFloor - 1] - stairsUp[currentFloor])) - 5;
    }
  }

  void smackRats() {
    for (Rat r : rats) {
      float distance = x - r.x;
      if (abs(y - r.y) < 4 &&((dir == LEFT && distance < 16 && distance > 8)
        || (dir == RIGHT && distance > -16 && distance < -8))) {
        r.scare();
      }
    }
  }

  void animationComplete() {
    setAnimation(0);
  }

  void draw() {
    if ((buttons & 16) != 0 && animation == 0) {
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

    super.draw();
  }
}