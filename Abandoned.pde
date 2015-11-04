static final int
FLOOR = 0,
STAIRS = 1,
SLAM = 2,
WALKING = 0,
EXITING = 1,
FLEEING = 2,
ENTERING = 4,
SCARED = 8,
INSIDE = 16;

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
int hiScore = 0;
int score = 0;

float SCALE = 1.0;

PImage bg;
PImage fg;
PImage rat;
PImage nums;

Platform[] floors = { new Platform(), new Platform(), new Platform(), new Platform() };

Baby baby = new Baby();

void setup() {
  fullScreen(JAVA2D);
  noSmooth();
  noStroke();

  SCALE = min(width / 192.0, height / 108.0);

  bg = loadImage("Background.png");
  fg = loadImage("FireEscape.png");
  rat = loadImage("Rat.png");
  nums = loadImage("Numbers.png");

  floors[0].y = 39;
  floors[1].y = 63;
  floors[1].hole = 168;
  floors[2].y = 87;
  floors[2].hole = 44;
  floors[3].y = 108;
  floors[3].hole = 168;
  
  new Stairway(132, 168, floors[3], floors[2]);
  new Stairway(85, 43, floors[2], floors[1]);
  new Stairway(126, 168, floors[1], floors[0]);
  
  for (Platform p : floors) {
    if (p.hole == 0) {
      continue;
    }
    
    Rat r = p.rat = new Rat(p);
    r.img = rat;
    r.frames = 8;
    r.animationSpeed = 4;
  }

  baby.img = loadImage("Baby.png");
  baby.frames = 16;
  baby.animationSpeed = 8;
  
  startGame();
}

void startLevel() {
  for (Platform p : floors) {
    Rat r = p.rat;
    
    if (r == null) {
      continue;
    }
    
    r.x = -16;
    r.state = INSIDE;
    r.framesLeft = (int) random(120);
  }
  
  baby.dir = RIGHT;
  baby.x = 8;
  baby.currentFloor = floors[floors.length - 1];
  baby.y = baby.currentFloor.y - baby.img.height / 2;
  baby.state = 0;
}

void startGame() {
  startLevel();
  score = 0;
}

void draw() {
  scale(SCALE);
  background(palette[0]);
  image(bg, 0, 0);

  for (Platform p : floors) {
    p.draw();
  }

  baby.draw();
  image(fg, 0, 0);
  drawScores();
}

void score(int points) {
  score += points;
  
  if (hiScore < score) {
    hiScore = score;
  }
  
  score %= 1000000;
  hiScore %= 1000000;
}

void drawNumber(int number) {
  for (int i = 0; i < 6; i++) {
    int digit = number % 10;
    number /= 10;
    copy(nums, digit * 4, 0, 4, nums.height, 0, 0, 4, nums.height);
    translate(-5, 0);
  }
}

void drawScores() {
  pushMatrix();
  translate(40, 4);
  drawNumber(score);
  popMatrix();
  translate(136, 4);
  drawNumber(hiScore);
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
  case ENTER:
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
  case ENTER:
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