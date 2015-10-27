class Stairway {
  int botX;
  int topX;
  Platform bottom;
  Platform top;
  
  Stairway(int botX, int topX, Platform bottom, Platform top) {
    this.botX = botX;
    this.topX = topX;
    this.bottom = bottom;
    this.top = top;
    bottom.up.add(this);
    top.down.add(this);
  }
  
  boolean descend(float x) {
    return abs(topX - x) < 4;
  }
  
  boolean climb(float x) {
    return abs(botX - x) < 4;
  }
  
  float getX(float y) {
    float percentage = (bottom.y - y) / (bottom.y - top.y);
    return botX + percentage * (topX - botX);
  }
}