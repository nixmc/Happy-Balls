/* @pjs preload="/pjs/HappyBalls/data/happy.png" */
/* @pjs preload="/pjs/HappyBalls/data/unhappy.png" */
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
int addParticleRate = externals.canvas.id == "happyBucket" ? 5 : 15;
boolean smiley = externals.canvas.id == "happyBucket" ? true : false;
PImage img;

void setup() {
  size(269, 340);
  noStroke();
  smooth();
  for (int i = 0; i < num; i++) {
    initParticle();
  }
  //println("Running on:  " + externals.canvas.id);
  img = loadImage(smiley ? "/pjs/HappyBalls/data/happy.png" : "/pjs/HappyBalls/data/unhappy.png");
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
  
  if (addParticles && frameCount % addParticleRate == 0) {
    initParticle();
  }
  
  // drawFace(smiley);
  pushStyle();
    stroke(66, 200);
    strokeCap(SQUARE);
    strokeWeight(6);
    line(0,0,0,height);
    line(0,height,width,height);
    line(width, 0, width, height);
  popStyle();
  image(img);
}

void drawFace(boolean smiling) {
  pushStyle();
    fill(66, 200);
    noStroke();
    rectMode(CENTER);
    rect(width * .3, height/2 - 50, 39, 39);
    rect(width * .7, height/2 - 50, 39, 39);
      pushStyle();
      fill(255);
      rect(width * .3 + 11, height/2 - 60, 8, 8);
      rect(width * .7 + 11, height/2 - 60, 8, 8);
      popStyle();
    noFill();
    stroke(66, 200);
    strokeCap(SQUARE);
    strokeWeight(6);
    line(0,0,0,height);
    line(0,height,width,height);
    line(width, 0, width, height);
    strokeWeight(18);
    ellipseMode(CENTER);
    if (smiling) {
      arc(width/2, height/2 - 50, min(width, height), min(width, height), PI/4, 3*PI/4);
    } else {
      arc(width/2, height, min(width, height), min(width, height), PI + PI/4, PI + 3*PI/4);
    }
  popStyle();
}

void initParticle() {
  float velX = random(-10, 10);
  float velY = 0;//random(6, 6);
  LimitedParticle p = new LimitedParticle(width/2, 0, velX, velY, radius, clr, GRAVITY, sinkListener);
  p.friction = FRICTION;
  particles.push(p);
  //println("No. of particles: " + particles.length);
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
