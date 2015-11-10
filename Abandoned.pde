static final int
FLOOR = 0,
STAIRS = 1,
SLAM = 2,
WALKING = 0,
EXITING = 1,
FLEEING = 2,
ENTERING = 4,
SCARED = 8,
INSIDE = 16,
CREDITS = 0,
MAIN_SCREEN = 1,
HIGH_SCREEN = 2,
GAME_OVER = 3,
PLAYING = 4;

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

/** These characters conform to the Ifi@UiO Arcade machine. */
char[] alphaChars = "0123456789-_.,:;!ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅÄÖÜ".toCharArray();
char[] playerOne = "1P:".toCharArray();
char[] hi = "HI:".toCharArray();

color[] palette = basePalette;

Score[] hiScores;
int buttons;
int score;
int hiScore;
int level;
int state = PLAYING;
int counter = 120;

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
  
  frameRate(10);

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
  
  loadScores();
  hiScore = hiScores[0].score;
  startGame();
}

void startLevel() {
  for (int i = 0; i < floors.length; i++) {
    Rat r = floors[i].rat;
    
    if (r == null) {
      continue;
    }
    
    r.speed = 1.0 + min(1, level * 0.25);
    r.x = -16;
    r.state = INSIDE;
    r.framesLeft = i * 60;
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

void nextState() {
  switch (state) {
    case CREDITS:
      state = MAIN_SCREEN;
      break;
    case MAIN_SCREEN:
      state = HIGH_SCREEN;
      break;
    case HIGH_SCREEN:
      state = MAIN_SCREEN;
      break;
    case GAME_OVER:
      state = HIGH_SCREEN;
      break;
    default:
      state = GAME_OVER;
      break;
  }
  
  counter = 300;
}

void draw() {
  scale(SCALE);
  background(palette[0]);
  switch (state) {
    case CREDITS:
      drawCredits();
      break;
    case MAIN_SCREEN:
      drawMainMenu();
      break;
    case HIGH_SCREEN:
      drawHighScores();
      break;
    case GAME_OVER:
      drawGameOver();
      break;
    default:
      drawGame();
      break;
  }
  
  if (counter == 0) {
    nextState();
  }
}

void drawGame() {
  image(bg, 0, 0);

  levels[level % levels.length].drawBG();
  baby.draw();
  levels[level % levels.length].drawFG();
  
  drawScores();
}

void drawCredits() {
  drawString("EVERYTHING:".toCharArray(), 69, 40);
  drawString("SIGMUND HANSEN".toCharArray(), 59, 50);
  counter--;
}

void drawMainMenu() {
  drawString("DUMPSTER BABY".toCharArray(), 69, 50);
  counter--;
}

void drawHighScores() {
  drawString("TOP 10 HIGH SCORES".toCharArray(), 49, 0);
  for (int i = 0; i < 10; i++) {
    pushMatrix();
    translate(12, i * 10 + 10);
    drawNumber(i + 1, false);
    popMatrix();
    pushMatrix();
    translate(17, i * 10 + 10);
    drawChar('.');
    drawString(hiScores[i].name, 5, 0);
    translate(140, 0);
    drawNumber(hiScores[i].score, true);
    popMatrix();
  }
  counter--;
}

void drawGameOver() {
  drawString("GAME OVER".toCharArray(), 69, 50);
  counter--;
}

void score(int points) {
  score += points;
  
  if (hiScore < score) {
    hiScore = score;
  }
  
  score %= 1000000;
  hiScore %= 1000000;
}

void drawNumber(int number, boolean leadingZeroes) {
  for (int i = 0; i < 6; i++) {
    int digit = number % 10;
    number /= 10;
    copy(alphabet, digit * 4, 0, 4, alphabet.height, 0, 0, 4, alphabet.height);
    translate(-5, 0);
    
    if (!leadingZeroes && number == 0) {
      break;
    }
  }
}

void drawChar(char c) {
  int index = -1;
  for (int i = 0; i < alphaChars.length; i++) {
    if (c == alphaChars[i]) {
      index = i;
      break;
    }
  }
  
  if (index == -1) {
    if (c != '?') {
      return;
    }
    
    index = alphaChars.length;
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
  drawNumber(score, true);
  translate(128, 0);
  drawString(hi, 0, 0);
  translate(40, 0);
  drawNumber(hiScore, true);
  popMatrix();
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

void loadScores() {
  JSONArray jsonScores = loadJSONObject("high.json").getJSONArray("scores");
  hiScores = new Score[jsonScores.size()];
  
  for (int i = 0; i < hiScores.length; i++) {
    JSONArray jsonScore = jsonScores.getJSONArray(i);
    hiScores[i] = new Score(jsonScore.getInt(0), jsonScore.getString(1));
  }
}

void saveScores() {
  JSONObject container = new JSONObject();
  JSONArray jsonScores = new JSONArray();
  
  for (Score score : hiScores) {
    JSONArray jsonScore = new JSONArray();
    jsonScore.append(score.score);
    jsonScore.append(new String(score.name));
    jsonScores.append(jsonScore);
  }
  
  container.setJSONArray("scores", jsonScores);
  saveJSONObject(container, "high.json");
}