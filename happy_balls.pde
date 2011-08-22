int numParticles = 5;
color happy = color(239, 240, 56, 150);
List<Particle> particles = new ArrayList<Particle>();
ParticleSystem physics;
float gravity = 9.8 / frameRate;
float drag = 0.05;
float radius = 35;
float attractionStrength = -50;
float attractionMinimumDistance = 5;
boolean addParticles = true;

void setup() {
  size(400, 400);
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
  for (Particle particle : particles) {
    handleBoundaryCollisions(particle);
  }
  
  physics.tick();

  background(255);
  
  noStroke();
  fill(happy);
  for (Particle particle : particles) {
    ellipse(particle.position.x, particle.position.y, radius * 2, radius * 2);   
  }
  
  if (addParticles && frameCount % 5 == 0) {
    initParticle();
    println("No. of particles: " + particles.size());
  }
}

void initParticle() {
  Particle p = physics.makeParticle(1.0, random(0, width), -2 * radius, 0);
  p.velocity.set(3, 4, 0);
  for (Particle particle : particles) {
    physics.makeAttraction(particle, p, attractionStrength, attractionMinimumDistance);
  }
  particles.add(p);
}

void handleBoundaryCollisions(Particle p) {
  if (p.position.x - radius < 0 || p.position.x + radius > width)
    p.velocity.set(-0.4 * p.velocity.x, p.velocity.y, 0);
  if (p.position.y + radius > height)
    p.velocity.set(p.velocity.x, -0.4 * p.velocity.y, 0);
  p.position.set(constrain(p.position.x, radius, width - radius), constrain(p.position.y, -2 * radius, height - radius), 0); 
}

void mousePressed() {
  initParticle();
}

void keyPressed() {
  if (key == ' ') {
    addParticles = !addParticles;
  }
}
