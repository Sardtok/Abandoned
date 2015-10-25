color[] basePalette = {
  #140c1c,
  #442434,
  #30346d,
  #4e4a4e,
  #854c30,
  #346524,
  #d04648,
  #757161,
  #597dce,
  #d27d2c,
  #8595a1,
  #6daa2c,
  #d2aa99,
  #6dc2ca,
  #dad45e,
  #deeed6
};

color[] palette = basePalette;

float SCALE = 1.0;

PImage bg;
PImage fg;
PImage rat;

Rat[] rats = new Rat[3];
Baby baby = new Baby();

void setup() {
  size(768, 432, JAVA2D);
  noSmooth();
  
  SCALE = min(width / 192.0, height / 108.0);

  bg = loadImage("Background.png");
  fg = loadImage("FireEscape.png");
  rat = loadImage("Rat.png");
  
  for (int i = 0; i < rats.length; i++) {
    Rat r = rats[i] = new Rat();
    r.img = rat;
    r.frames = 7;
    r.x = 60;
    r.y = 61 + i * 24;
  }
  
  baby.img = loadImage("Baby.png");
  baby.frames = 5;
  baby.x = 96;
  baby.y = 54;
}

void draw() {
  scale(SCALE);
  background(palette[0]);
  image(bg, 0, 0);
  
  for (Rat r : rats) {
    r.draw();
  }
  
  baby.draw();
  image(fg, 0, 0);
}