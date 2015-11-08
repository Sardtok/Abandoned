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

char[] playerOne = "1p:".toCharArray();
char[] hi = "hi:".toCharArray();

color[] palette = basePalette;

int buttons = 0;
int hiScore = 0;
int score = 0;
int level = 0;

float SCALE = 1.0;

PImage bg;
PImage rat;
PImage alphabet;

Platform[] floors = { new Platform(), new Platform(), new Platform(), new Platform() };
Level[] levels = new Level[1];

Baby baby = new Baby();

void setup() {
  fullScreen(JAVA2D);
  noSmooth();
  noStroke();

  SCALE = min(width / 192.0, height / 108.0);

  bg = loadImage("Background.png");
  rat = loadImage("Rat.png");
  alphabet = loadImage("Alphabet.png");

  levels[0] = new Level();
  levels[0].floors.add(floors[0]);
  levels[0].floors.add(floors[1]);
  levels[0].floors.add(floors[2]);
  levels[0].floors.add(floors[3]);
  floors[0].y = 39;
  floors[0].left = 32;
  floors[0].right = 180;
  floors[1].y = 63;
  floors[1].hole = 168;
  floors[1].left = 32;
  floors[1].right = 180;
  floors[2].y = 87;
  floors[2].hole = 44;
  floors[2].left = 32;
  floors[2].right = 180;
  floors[3].y = 108;
  floors[3].hole = 168;
  floors[3].left = 0;
  floors[3].right = 192;
  
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

  levels[0].renderForeground();
  startGame();
}

void startLevel() {
  for (Platform p : floors) {
    Rat r = p.rat;
    
    if (r == null) {
      continue;
    }
    
    r.speed = 1.0 + min(1, level * 0.25);
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
  level = 0;
  startLevel();
  score = 0;
}

void draw() {
  scale(SCALE);
  background(palette[0]);
  image(bg, 0, 0);

  levels[level % levels.length].drawBG();
  baby.draw();
  levels[level % levels.length].drawFG();
  
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
    copy(alphabet, digit * 4, 0, 4, alphabet.height, 0, 0, 4, alphabet.height);
    translate(-5, 0);
  }
}

void drawChar(char c) {
  int index = -1;
  switch (c) {
  case '.':
    index = 36;
    break;
  case ':':
    index = 37;
    break;
  case '!':
    index = 38;
    break;
  case '?':
    index = 39;
    break;
  case '0':
  case '1':
  case '2':
  case '3':
  case '4':
  case '5':
  case '6':
  case '7':
  case '8':
  case '9':
    index = c - '0';
    break;
  default:
    if (c >= 'a' && c <= 'z') {
      index = c - 'a' + 10;
    }
    break;
  }
  copy(alphabet, index * 4, 0, 4, alphabet.height, 0, 0, 4, alphabet.height);
}

void drawString(char[] s, float x, float y) {
  pushMatrix();
  translate(x, y);
  for (char c : s) {
    drawChar(c);
    translate(5, 0);
  }
  popMatrix();
}

void drawScores() {
  pushMatrix();
  translate(4, 4);
  drawString(playerOne, 0, 0);
  translate(40, 0);
  drawNumber(score);
  popMatrix();
  translate(144, 4);
  drawString(hi, 0, 0);
  translate(40, 0);
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