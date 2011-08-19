int num = 0;
color happy = color(239, 240, 56);
color unhappy = color(176, 210, 235);
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
  float velY = random(5, 20);
  println("velX: " + velX);
  println("velY: " + velY);
  particles.add(new LimitedParticle(width/2, 0, velX, velY, 40, clr));
}

void mousePressed() {
  initParticle();
}
