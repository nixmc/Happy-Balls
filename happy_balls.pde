int num = 0;
color happy = color(239, 240, 56);
color unhappy = color(176, 210, 235);
float GRAVITY = 9.8 / frameRate;
float FRICTION = 0.4;
List<LimitedParticle> particles = new ArrayList<LimitedParticle>();

void setup() {
  size(500, 500);
  noStroke();
  smooth();
  for (int i = 0; i < num; i++) {
    initParticle();
  }
}

void draw() {
  fill(255);
  rect(0, 0, width, height);
  for (LimitedParticle p : particles) {
    p.update();
    p.display();
  }
}

void initParticle() {
  color clr = second() % 2 == 0 ? happy : unhappy;
  float velX = random(-10, 10);
  float velY = 0;//random(6, 6);
  println("velX: " + velX);
  println("velY: " + velY);
  LimitedParticle p = new LimitedParticle(width/2, 0, velX, velY, 40, clr, GRAVITY);
  p.friction = FRICTION;
  particles.add(p);
}

void mousePressed() {
  initParticle();
}

void keyPressed() {
  if (keyCode == UP) {
    FRICTION += 0.05;
  } else if (keyCode == DOWN) {
    FRICTION -= 0.05;
  }
  println("friction: " + FRICTION);
}
