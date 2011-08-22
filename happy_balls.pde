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
  
  checkObjectCollision(particles);
  
  if (frameCount % 10 == 0) {
    initParticle();
  }
}

void initParticle() {
  color clr = second() % 2 == 0 ? happy : unhappy;
  float velX = random(-10, 10);
  float velY = 0;//random(6, 6);
//  println("velX: " + velX);
//  println("velY: " + velY);
  LimitedParticle p = new LimitedParticle(width/2, 0, velX, velY, 40, clr, GRAVITY);
  p.friction = FRICTION;
  particles.add(p);
}

void checkObjectCollision(List<LimitedParticle> particles) {
  Map<LimitedParticle, List<LimitedParticle>> processedPairs = new HashMap<LimitedParticle, List<LimitedParticle>>();
  
  for (LimitedParticle p1 : particles) {
    
    List<LimitedParticle> p1Processed = processedPairs.get(p1);
    if (p1Processed == null) {
      p1Processed = new ArrayList<LimitedParticle>();
    }
    
    if (p1.resting) {
      continue;
    }
    
    for (LimitedParticle p2 : particles) {
      if (p1.equals(p2)) {
        // Particle can't collide with itself
        // println("Particle can't collide with itself");
        continue;
      }
      
      List<LimitedParticle> p2Processed = processedPairs.get(p2);
      if (p2Processed == null) {
        p2Processed = new ArrayList<LimitedParticle>();
      }
      
      if (p1Processed.contains(p2) || p2Processed.contains(p1)) {
        // This pair have already been processed
        // println("Pair processed previously");
        continue;
      }
      
      // Record that this pair have been processed
      p2Processed.add(p1);
      p1Processed.add(p2);
      
      processedPairs.put(p1, p1Processed);
      processedPairs.put(p2, p2Processed);
      
      // Use an adapter so we can reuse the example from http://processingjs.org/learning/topic/circlecollision
      
      Ball[] b = {
        new Ball(p1.x, p1.y, p1.radius), new Ball(p2.x, p2.y, p2.radius)
      };
      
      Vect2D[] v = {
        new Vect2D(p1.vx, p1.vy), new Vect2D(p2.vx, p2.vy)
      };
      
      Object[] bv = checkObjectCollision(b, v);
      
      b = (Ball[])bv[0]; v = (Vect2D[])bv[1];
      
      p1.x = b[0].x; p1.y = b[0].y;
      p2.x = b[1].x; p2.y = b[1].y;
      
      p1.vx = v[0].vx; p1.vy = v[0].vy;
      p2.vx = v[1].vx; p2.vy = v[1].vy;      
    }
  }
}


// Modified from http://processingjs.org/learning/topic/circlecollision
Object[] checkObjectCollision(Ball[] b, Vect2D[] v) {

  // get distances between the balls components
  Vect2D bVect = new Vect2D();
  bVect.vx = b[1].x - b[0].x;
  bVect.vy = b[1].y - b[0].y;

  // calculate magnitude of the vector separating the balls
  float bVectMag = sqrt(bVect.vx * bVect.vx + bVect.vy * bVect.vy);
  if (bVectMag < b[0].r + b[1].r){
    // get angle of bVect
    float theta  = atan2(bVect.vy, bVect.vx);
    // precalculate trig values
    float sine = sin(theta);
    float cosine = cos(theta);

    /* bTemp will hold rotated ball positions. You 
     just need to worry about bTemp[1] position*/
    Ball[] bTemp = {  
      new Ball(), new Ball()      };
    /* b[1]'s position is relative to b[0]'s
     so you can use the vector between them (bVect) as the 
     reference point in the rotation expressions.
     bTemp[0].x and bTemp[0].y will initialize
     automatically to 0.0, which is what you want
     since b[1] will rotate around b[0] */
    bTemp[1].x  = cosine * bVect.vx + sine * bVect.vy;
    bTemp[1].y  = cosine * bVect.vy - sine * bVect.vx;

    // rotate Temporary velocities
    Vect2D[] vTemp = { 
      new Vect2D(), new Vect2D()     };
    vTemp[0].vx  = cosine * v[0].vx + sine * v[0].vy;
    vTemp[0].vy  = cosine * v[0].vy - sine * v[0].vx;
    vTemp[1].vx  = cosine * v[1].vx + sine * v[1].vy;
    vTemp[1].vy  = cosine * v[1].vy - sine * v[1].vx;

    /* Now that velocities are rotated, you can use 1D
     conservation of momentum equations to calculate 
     the final velocity along the x-axis. */
    Vect2D[] vFinal = {  
      new Vect2D(), new Vect2D()      };
    // final rotated velocity for b[0]
    vFinal[0].vx = ((b[0].m - b[1].m) * vTemp[0].vx + 2 * b[1].m * 
      vTemp[1].vx) / (b[0].m + b[1].m);
    vFinal[0].vy = vTemp[0].vy;
    // final rotated velocity for b[0]
    vFinal[1].vx = ((b[1].m - b[0].m) * vTemp[1].vx + 2 * b[0].m * 
      vTemp[0].vx) / (b[0].m + b[1].m);
    vFinal[1].vy = vTemp[1].vy;

    // hack to avoid clumping
    bTemp[0].x += vFinal[0].vx;
    bTemp[1].x += vFinal[1].vx;

    /* Rotate ball positions and velocities back
     Reverse signs in trig expressions to rotate 
     in the opposite direction */
    // rotate balls
    Ball[] bFinal = { 
      new Ball(), new Ball()     };
    bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
    bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
    bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
    bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

    // update balls to screen position
    b[1].x = b[0].x + bFinal[1].x;
    b[1].y = b[0].y + bFinal[1].y;
    b[0].x = b[0].x + bFinal[0].x;
    b[0].y = b[0].y + bFinal[0].y;

    // update velocities
    v[0].vx = cosine * vFinal[0].vx - sine * vFinal[0].vy;
    v[0].vy = cosine * vFinal[0].vy + sine * vFinal[0].vx;
    v[1].vx = cosine * vFinal[1].vx - sine * vFinal[1].vy;
    v[1].vy = cosine * vFinal[1].vy + sine * vFinal[1].vx;    
  }
  
  // Return updated b, v
  Object[] retval = {
    b, v
  }; 
  
  return retval;
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
