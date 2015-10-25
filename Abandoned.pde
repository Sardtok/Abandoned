static final int
FLOOR = 0,
STAIRS = 1,
SCARED = 2;

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

int buttons = 0;

float SCALE = 1.0;

PImage bg;
PImage fg;
PImage rat;

int[] mouseHolePositions = {170, 42, 170};
int[] floorPositions = { 39, 63, 87, 108 };
int[] stairsUp = {-16, 124, 88, 132};
int[] stairsDown = {168, 44, 168, -16};
Rat[] rats = new Rat[3];
Baby baby = new Baby();

void setup() {
  fullScreen(JAVA2D);
  noSmooth();

  SCALE = min(width / 192.0, height / 108.0);

  bg = loadImage("Background.png");
  fg = loadImage("FireEscape.png");
  rat = loadImage("Rat.png");

  for (int i = 0; i < rats.length; i++) {
    Rat r = rats[i] = new Rat();
    r.img = rat;
    r.frames = 8;
  }

  baby.img = loadImage("Baby.png");
  baby.frames = 7;
  
  startGame();
}

void startGame() {
  for (int i = 0; i < rats.length; i++) {
    Rat r = rats[i];
    r.x = 60;
    r.y = floorPositions[i + 1] - 4;
  }
  baby.x = 96;
  baby.y = floorPositions[floorPositions.length - 1] - baby.img.height / 2;
  baby.state = 0;
  baby.currentFloor = 3;
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

void keyPressed() {
  switch (keyCode) {
  case LEFT:
    buttons |= 1;
    break;
  case RIGHT:
    buttons |= 2;
    break;
  case UP:
    buttons |= 4;
    break;
  case DOWN:
    buttons |= 8;
    break;
  case RETURN:
    buttons |= 16;
    break;
  }
  
  switch (key) {
  case 'a':
    buttons |= 1;
    break;
  case 'd':
    buttons |= 2;
    break;
  case 'w':
    buttons |= 4;
    break;
  case 's':
    buttons |= 8;
    break;
  case ' ':
    buttons |= 16;
    break;
  }
}

void keyReleased() {
  switch (keyCode) {
  case LEFT:
    buttons &= ~1;
    break;
  case RIGHT:
    buttons &= ~2;
    break;
  case UP:
    buttons &= ~4;
    break;
  case DOWN:
    buttons &= ~8;
    break;
  case RETURN:
    buttons &= ~16;
    break;
  }
  
  switch (key) {
  case 'a':
    buttons &= ~1;
    break;
  case 'd':
    buttons &= ~2;
    break;
  case 'w':
    buttons &= ~4;
    break;
  case 's':
    buttons &= ~8;
    break;
  case ' ':
    buttons &= ~16;
    break;
  }
}