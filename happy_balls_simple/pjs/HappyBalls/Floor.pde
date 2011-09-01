static class Floor {
  static float y = 340;
  static float linesPerBall = 1;
  static float ballsConsumed = 0;
  
  static void update(float proportionSunk) {
      ballsConsumed += proportionSunk;
      y -= (linesPerBall * proportionSunk);
  }
}
