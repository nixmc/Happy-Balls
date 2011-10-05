static class Floor {
  static float y = 340;
  static float linesPerBall = 5;
  static float ballsConsumed = 0;
  
  static void update(float proportionSunk) {
      ballsConsumed += proportionSunk;
      y -= (linesPerBall * proportionSunk);
  }
}
