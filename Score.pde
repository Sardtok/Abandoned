class Score {
  int score;
  char[] name;
  
  Score(int score, String name) {
    this.score = score;
    this.name = name.toCharArray();
  }
  
  Score(int score, char[] name) {
    this.score = score;
    this.name = name.clone();
  }
}