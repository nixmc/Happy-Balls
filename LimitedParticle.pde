class LimitedParticle extends Particle {
  float friction = 0.4;
  float newVX = 0, newVY = 0, oldVX = 0, oldVY = 0;
  boolean resting = false;
  
  LimitedParticle(int ix, int iy, float ivx, float ivy, float ir, color ic, float ig) {
    super(ix, iy, ivx, ivy, ir, ic, ig);
  }
  
  void update() {
//    vx *= friction;
//    vy *= friction;
    limit();
    super.update();
  }
  
  void limit() {
    newVX = vx; newVY = vy;
    if (y > height-radius) {
      // bounce!
      newVX *= friction;
      newVY *= friction;
      newVY = -newVY;
      y = constrain(y, -height*height, height-radius);
    }
    if ((x < radius) || (x > width-radius)) {
      newVX = -vx;
      x = constrain(x, radius, width-radius);
    }
    resting = round(newVX * 100) == round(oldVX * 100) && round(newVY * 100) == round(oldVY * 100);
//    println("oldVX, newVX: " + oldVX + ", " + newVX);
//    println("oldVY, newVY: " + oldVY + ", " + newVY);
//    println("resting? " + resting);
    oldVX = newVX;
    oldVY = newVY;
    vx = newVX;
    vy = newVY;
  }
}
