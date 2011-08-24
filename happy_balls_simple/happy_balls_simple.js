int num = 0;
color happy = color(239, 240, 56);
color unhappy = color(176, 210, 235);
color clr = externals.canvas.id == "happyBucket" ? happy : unhappy;
float radius = 40;
float GRAVITY = 9.8 / frameRate;
float FRICTION = 0.4;
// List<LimitedParticle> particles = new ArrayList<LimitedParticle>();
var particles = [];
SinkListener sinkListener = new SinkListenerImpl(); 
boolean addParticles = false;

void setup() {
  size(500, 500);
  noStroke();
  smooth();
  for (int i = 0; i < num; i++) {
    initParticle();
  }
  println("Running on:  " + externals.canvas.id);
}

void draw() {
  fill(255);
  rect(0, 0, width, height);
  
  particles.forEach(function(p) {
    if (!p.sunk) {
      p.update();
      p.display();
    }    
  });
  
  fill(clr);
  rect(0, Floor.y, width, height - Floor.y);
  
  if (addParticles && frameCount % 5 == 0) {
    initParticle();
  }
}

void initParticle() {
  float velX = random(-10, 10);
  float velY = 0;//random(6, 6);
  LimitedParticle p = new LimitedParticle(width/2, 0, velX, velY, radius, clr, GRAVITY, sinkListener);
  p.friction = FRICTION;
  particles.push(p);
  println("No. of particles: " + particles.length);
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
