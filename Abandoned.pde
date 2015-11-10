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
  PLAYING = 4,
  STATE_DELAY = 300,
  EDIT_DELAY = 10,
  L = 1, 
  R = 2, 
  U = 4, 
  D = 8, 
  S = 16;

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
char[] input = new char[3];

color[] palette = basePalette;

ArrayList<Score> hiScores;
int buttons;
int score;
int hiScore;
int level;
int state = CREDITS;
int nextState = MAIN_SCREEN;
int counter = 120;

int place;
int editPos;
int nextEditPos;
int editIncrease;
boolean editDone;

float SCALE = 1.0;

PImage credits;
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

  credits = loadImage("Credits.png");
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
  hiScore = hiScores.get(0).score;
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
  baby.lives = 3;
  startLevel();
  score = 0;
}

void nextState() {
  counter = STATE_DELAY;
  state = nextState;
  switch (state) {
  case CREDITS:
    nextState = MAIN_SCREEN;
    break;
  case MAIN_SCREEN:
    nextState = HIGH_SCREEN;
    break;
  case HIGH_SCREEN:
    nextState = MAIN_SCREEN;
    break;
  case GAME_OVER:
    place = 0;
    for (Score s : hiScores) {
      if (score > s.score) {
        break;
      }

      place++;
    }

    for (int i = 0; i  < input.length; i++) {
      input[i] = 'A';
    }

    editPos = 0;
    counter = EDIT_DELAY;
    nextState = HIGH_SCREEN;
    break;
  default:
    startGame();
    nextState = GAME_OVER;
    break;
  }
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
  image(credits, 0, 0);
  counter--;

  if (counter < STATE_DELAY - 10 && (buttons & S) != 0) {
    counter = min(counter, 10);
  }
}

void drawMainMenu() {
  drawString("DUMPSTER BABY".toCharArray(), 64, 40);
  drawString("PRESS START".toCharArray(), 69, 50);
  counter--;

  if (counter < STATE_DELAY - 10 && (buttons & S) != 0) {
    nextState = PLAYING;
    counter = 10;
  }
}

void drawHighScores() {
  drawString("TOP 10 HIGH SCORES".toCharArray(), 49, 0);
  int i = 0;
  for (Score score : hiScores) {
    if (i == 10) {
      break;
    }
    
    pushMatrix();
    translate(12, i * 10 + 10);
    drawNumber(i + 1, false);
    popMatrix();
    pushMatrix();
    translate(17, i * 10 + 10);
    drawChar('.');
    drawString(score.name, 5, 0);
    translate(140, 0);
    drawNumber(score.score, true);
    popMatrix();
    i++;
  }
  counter--;

  if (counter < STATE_DELAY - 10 && (buttons & S) != 0) {
    counter = min(counter, 10);
  }
}

int getIndex(char c) {
  for (int i = 0; i < alphaChars.length; i++) {
    if (c == alphaChars[i]) {
      return i;
    }
  }

  return -1;
}

void drawGameOver() {
  counter--;
  if (counter < EDIT_DELAY - 3) {
    switch (buttons) {
    case L:
      nextEditPos = editPos - 1;
      break;
    case R:
      nextEditPos = editPos + 1;
      break;
    case S:
      nextEditPos = editPos + 1;
      editDone = nextEditPos == input.length;
      break;
    case U:
      editIncrease = 1;
      break;
    case D:
      editIncrease = -1;
      break;
    }
  }
  
  if (counter == 0) {
    counter = EDIT_DELAY;

    input[editPos] = alphaChars[(getIndex(input[editPos]) + alphaChars.length + editIncrease) % alphaChars.length];
    editPos = nextEditPos;

    if (editPos < 0) {
      editPos = input.length - 1;
    }

    if (editDone) {
      counter = 0;
      hiScores.add(place, new Score(score, input));
      saveScores();
    }

    editPos = editPos % input.length;
    editIncrease = 0;
    editDone = false;
  }

  drawString("GAME OVER".toCharArray(), 72, 40);
  drawString(input, 96, 50);
  translate(88, 50);
  drawChar(':');
  translate(5 * editPos + 8, 2);
  drawChar('_');
  translate(-10 - 5 * editPos, -2);
  drawNumber(place + 1, false);
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
  int index = getIndex(c);

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
    buttons |= L;
    break;
  case RIGHT:
    buttons |= R;
    break;
  case UP:
    buttons |= U;
    break;
  case DOWN:
    buttons |= D;
    break;
  case RETURN:
  case ENTER:
    buttons |= S;
    break;
  }

  switch (key) {
  case 'a':
    buttons |= L;
    break;
  case 'd':
    buttons |= R;
    break;
  case 'w':
    buttons |= U;
    break;
  case 's':
    buttons |= D;
    break;
  case ' ':
    buttons |= S;
    break;
  }
}

void keyReleased() {
  switch (keyCode) {
  case LEFT:
    buttons &= ~L;
    break;
  case RIGHT:
    buttons &= ~R;
    break;
  case UP:
    buttons &= ~U;
    break;
  case DOWN:
    buttons &= ~D;
    break;
  case RETURN:
  case ENTER:
    buttons &= ~S;
    break;
  }

  switch (key) {
  case 'a':
    buttons &= ~L;
    break;
  case 'd':
    buttons &= ~R;
    break;
  case 'w':
    buttons &= ~U;
    break;
  case 's':
    buttons &= ~D;
    break;
  case ' ':
    buttons &= ~S;
    break;
  }
}

void loadScores() {
  JSONArray jsonScores = loadJSONObject("high.json").getJSONArray("scores");
  hiScores = new ArrayList<Score>(jsonScores.size());

  for (int i = 0; i < jsonScores.size(); i++) {
    JSONArray jsonScore = jsonScores.getJSONArray(i);
    hiScores.add(new Score(jsonScore.getInt(0), jsonScore.getString(1)));
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