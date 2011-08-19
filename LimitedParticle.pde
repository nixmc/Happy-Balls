class LimitedParticle extends Particle {
  float friction = 0.98;
  
  LimitedParticle(int ix, int iy, float ivx, float ivy, float ir, color ic) {
    super(ix, iy, ivx, ivy, ir, ic);
  }
  
  void update() {
    vx *= friction;
    vy *= friction;
    super.update();
    limit();
  }
  
  void limit() {
    if (y > height-radius) {
      vy = -vy;
      y = constrain(y, -height*height, height-radius);
    }
    if ((x < radius) || (x > width-radius)) {
      vx = -vx;
      x = constrain(x, radius, width-radius);
    }
  }
}
