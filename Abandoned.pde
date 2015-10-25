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

void setup() {
  size(768, 432, JAVA2D);
  noSmooth();
  
  SCALE = min(width / 192.0, height / 108.0);

  bg = loadImage("Background.png");
}

void draw() {
  scale(SCALE);
  background(palette[0]);
  image(bg, 0, 0);
}