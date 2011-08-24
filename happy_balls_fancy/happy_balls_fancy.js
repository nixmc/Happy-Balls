int numParticles = 5;
color happy = color(239, 240, 56, 150);
var particles = [];
//List<Particle> particles = new ArrayList<Particle>();
ParticleSystem physics;
float gravity = 9.8 / frameRate;
float drag = 0.05;
float radius = 35; //35;
float attractionStrength = -radius * 5; //-50;
float attractionMinimumDistance = radius / 4; //5;
boolean addParticles = true;

void setup() {
  size(500, 500);
  smooth();
  ellipseMode(CENTER);
  noStroke();
  
  physics = new ParticleSystem();
  physics.setGravity(gravity);
  physics.setDrag(drag);
  
  // Make particles
  for (int i = 0; i < numParticles; i++) {
    initParticle();
  }
}

void draw() {
//  for (Particle particle : particles) {
//    handleBoundaryCollisions(particle);
//  }
  particles.forEach(function(particle){
    handleBoundaryCollisions(particle);
  });
  
  physics.tick();

  background(255);
  
  noStroke();
  fill(happy);
//  for (Particle particle : particles) {
//    ellipse(particle.position.x, particle.position.y, radius * 2, radius * 2);
//  }
  particles.forEach(function(particle){
    ellipse(particle.position.x, particle.position.y, radius * 2, radius * 2);
  });

  if (addParticles && frameCount % 5 == 0) {
    initParticle();
//    println("No. of particles: " + particles.size());
    println("No. of particles: " + particles.length);
  }
}

void initParticle() {
  //Particle p = physics.makeParticle(1.0, random(width * 0.25, width * 0.75), -2 * radius, 0);
  Particle p = physics.makeParticle(1.0, width / 2, -2 * radius, 0);
  p.velocity.set(3, 0, 0);
//  for (Particle particle : particles) {
//    physics.makeAttraction(particle, p, attractionStrength, attractionMinimumDistance);
//  }
  particles.forEach(function(particle){
    physics.makeAttraction(particle, p, attractionStrength, attractionMinimumDistance);
  });
//  particles.add(p);
  particles.push(p);
}

void handleBoundaryCollisions(Particle p) {
  if (p.position.x - radius < 0 || p.position.x + radius > width)
    p.velocity.set(-0.4 * p.velocity.x, p.velocity.y, 0);
  if (p.position.y + radius > height)
    p.velocity.set(p.velocity.x, -0.4 * p.velocity.y, 0);
  p.position.set(constrain(p.position.x, radius, width - radius), constrain(p.position.y, -2 * radius, height - radius), 0); 
}

float distanceBetween(Particle p1, Particle p2) {
  return sqrt(pow(p1.position.x - p2.position.x, 2) + pow(p1.position.y - p2.position.y, 2));
}

void mousePressed() {
  initParticle();
}

void keyPressed() {
  if (key == ' ') {
    addParticles = !addParticles;
  }
}
