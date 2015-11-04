class Platform {
  ArrayList<Stairway> up = new ArrayList<Stairway>();
  ArrayList<Stairway> down = new ArrayList<Stairway>();
  int y;
  int left;
  int right;
  int hole;
  Rat rat;
  
  void draw() {
    if (rat != null) {
      rat.draw();
    }
  }
}