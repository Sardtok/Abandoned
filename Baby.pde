class Baby extends PhysicalObject {
  
  void draw() {
    if (frameCount % 8 == 0)
    frame = (frame + 1) % 3;
    super.draw();
  }
}