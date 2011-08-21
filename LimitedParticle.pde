class LimitedParticle extends Particle {
  private float friction = 0.4;
  
  LimitedParticle(int ix, int iy, float ivx, float ivy, float ir, color ic, float ig) {
    super(ix, iy, ivx, ivy, ir, ic, ig);
  }
  
  void update() {
//    vx *= friction;
//    vy *= friction;
    super.update();
    limit();
  }
  
  void limit() {
    if (y > height-radius) {
      // bounce!
      vx *= friction;
      vy *= friction;
      vy = -vy;
      y = constrain(y, -height*height, height-radius);
    }
    if ((x < radius) || (x > width-radius)) {
      vx = -vx;
      x = constrain(x, radius, width-radius);
    }
  }
}
