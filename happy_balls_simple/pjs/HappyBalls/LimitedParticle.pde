class LimitedParticle extends Particle {
  float friction = 0.4;
  float newVX = 0, newVY = 0, oldVX = 0, oldVY = 0;
  boolean resting = false;
  boolean sunk = false;
  SinkListener sinkListener = null;
  
  LimitedParticle(int ix, int iy, float ivx, float ivy, float ir, color ic, float ig) {
    this(ix, iy, ivx, ivy, ir, ic, ig, null);
  }
  
  LimitedParticle(int ix, int iy, float ivx, float ivy, float ir, color ic, float ig, SinkListener sl) {
    super(ix, iy, ivx, ivy, ir, ic, ig);
    sinkListener = sl;
  }
  
  void update() {
    if (!resting) {
      limit();
      super.update();
    } else {
      sink();
    }
  }
  
  void limit() {
    newVX = vx; newVY = vy;
    if (y > Floor.y-radius) {
      // bounce!
      newVX *= friction;
      newVY *= friction;
      newVY = -newVY;
      y = constrain(y, -Floor.y*Floor.y, Floor.y-radius);
    }
    if ((x < radius) || (x > width-radius)) {
      newVX = -vx;
      x = constrain(x, radius, width-radius);
    }
    resting = round(newVX * 100) == round(oldVX * 100) && round(newVY * 100) == round(oldVY * 100);
    oldVX = newVX;
    oldVY = newVY;
    vx = newVX;
    vy = newVY;
  }
  
  void sink() {
    y += 1;
    sunk = y - radius > Floor.y;
    if (!sunk && sinkListener != null) {
      sinkListener.sinking(this);
    }
  }
}
