class Particle {
  float x, y;
  float vx, vy;
  float radius;
  float gravity = 0.1;
  color clr;
  float alpha = 200;
  
  Particle(int xpos, int ypos, float velx, float vely, float r, color c, float g) {
    x = xpos;
    y = ypos;
    vx = velx;
    vy = vely;
    radius = r;
    clr = c;
    gravity = g;
  }
  
  void update() {
    vy = vy + gravity;
    y += vy;
    x += vx;
  }
  
  void display() {
    fill(clr, alpha);
    ellipse(x, y, radius * 2, radius * 2);
  }
}


