int num = 1;
color happy = color(239, 240, 56);
color unhappy = color(176, 210, 235);
float radius = 40;
float GRAVITY = 9.8 / frameRate;
float FRICTION = 0.4;
List<LimitedParticle> particles = new ArrayList<LimitedParticle>();
SinkListener sinkListener = new SinkListenerImpl(); 
Floor ground = new Floor();
boolean addParticles = true;

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
    if (!p.sunk) {
      p.update();
      p.display();
    }
  }
  
  fill(happy);
  rect(0, Floor.y, width, height - Floor.y);
  
  if (addParticles && frameCount % 5 == 0) {
    initParticle();
  }
}

void initParticle() {
//  color clr = second() % 2 == 0 ? happy : unhappy;
  float velX = random(-10, 10);
  float velY = 0;//random(6, 6);
  LimitedParticle p = new LimitedParticle(width/2, 0, velX, velY, radius, happy, GRAVITY, sinkListener);
  p.friction = FRICTION;
  particles.add(p);
  println("No. of particles: " + particles.size());
}

void mousePressed() {
  initParticle();
}

void keyPressed() {
  if (keyCode == UP) {
    FRICTION += 0.05;
  } else if (keyCode == DOWN) {
    FRICTION -= 0.05;
  } else if (key == ' ') {
    addParticles = !addParticles;
  }
}
