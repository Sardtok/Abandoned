class PhysicalObject {
  PImage img;
  int frame;
  int frames;
  int framesLeft;
  float x;
  float y;
  int dir = RIGHT;

  int animationSpeed;
  int animation = 0;
  int aniIndex = 0;
  int[][] animations;
  
  void setAnimation(int animation) {
    this.animation = animation;
    aniIndex = 0;
    framesLeft = animationSpeed;
  }
  
  void draw() {
    pushMatrix();
    translate(x, y);
    if (dir == LEFT) {
      scale(-1, 1);
    }
    int w = img.width / frames;
    copy(img, frame * w, 0, w, img.height, -w / 2, -img.height / 2, w, img.height);
    
    popMatrix();
  }
}