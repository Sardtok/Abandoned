class Baby extends PhysicalObject {

  int aniIndex = 0;
  int[] walkAnimation = { 0, 1, 2, 0, 3, 4 };

  int state = 0;
  int currentFloor = 3;

  void draw() {
    if (frameCount % 8 == 0) {
      aniIndex = (aniIndex + 1) % walkAnimation.length;
      frame = walkAnimation[aniIndex];
    }

    if ((buttons & 1) != 0 && state == FLOOR) {
      if ((buttons & 2) == 0) {
        dir = LEFT;
        x--;
      }
    } else if ((buttons & 2) != 0 && state == FLOOR) {
      dir = RIGHT;
      x += 0.5;
    }

    if ((buttons & 4) != 0) {
      if ((buttons & 8) == 0) {
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
      }
      if (state == STAIRS) {
        dir = currentFloor % 2 == 0 ? LEFT : RIGHT;
        float along = (float)(y - floorPositions[currentFloor]) / (floorPositions[currentFloor - 1] - floorPositions[currentFloor]);
        if (currentFloor % 2 == 0) {
          x = max(stairsDown[currentFloor - 1], stairsUp[currentFloor]) - (int)(along * abs(stairsDown[currentFloor - 1] - stairsUp[currentFloor])) + 5;
        } else {
          x = min(stairsDown[currentFloor - 1], stairsUp[currentFloor]) + (int)(along * abs(stairsDown[currentFloor - 1] - stairsUp[currentFloor])) - 5;
        }
      }
    } else if ((buttons & 8) != 0) {
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
      if (state == STAIRS) {
        dir = currentFloor % 2 == 0 ? RIGHT : LEFT;
        float along = (float)(y - floorPositions[currentFloor]) / (floorPositions[currentFloor - 1] - floorPositions[currentFloor]);
        if (currentFloor % 2 == 0) {
          x = max(stairsDown[currentFloor - 1], stairsUp[currentFloor]) - (int)(along * abs(stairsDown[currentFloor - 1] - stairsUp[currentFloor])) + 5;
        } else {
          x = min(stairsDown[currentFloor - 1], stairsUp[currentFloor]) + (int)(along * abs(stairsDown[currentFloor - 1] - stairsUp[currentFloor])) - 5;
        }
      }
    }

    super.draw();
  }
}