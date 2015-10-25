class PhysicalObject {
  PImage img;
  int frame;
  int frames;
  int x;
  int y;
  int dir = RIGHT;
  
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