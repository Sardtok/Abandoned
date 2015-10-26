abstract class PhysicalObject {
  PImage img;
  int frames;
  int framesLeft;
  float x;
  float y;
  int dir = RIGHT;

  int state;
  int animationSpeed;
  int animation = 0;
  int aniIndex = 0;
  int[][] animations;

  abstract void animationComplete();

  void setAnimation(int animation) {
    this.animation = animation;
    aniIndex = 0;
    framesLeft = animationSpeed;
  }

  void draw() {
    framesLeft--;
    if (framesLeft <= 0) {
      aniIndex++;
      framesLeft = animationSpeed;
      if (aniIndex >= animations[animation].length) {
        animationComplete();
      }
    }

    pushMatrix();
    translate(x, y);
    if (dir == LEFT) {
      scale(-1, 1);
    }
    int w = img.width / frames;
    copy(img, animations[animation][aniIndex] * w, 0, w, img.height, -w / 2, -img.height / 2, w, img.height);

    popMatrix();
  }
}