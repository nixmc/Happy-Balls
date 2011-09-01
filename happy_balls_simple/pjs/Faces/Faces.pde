int offset = 0;
int happyColour = color(239, 240, 56);
int sadColour = color(176, 210, 235);
boolean smiley = true;

void setup() {
  size(269, 340);
  smooth();
}

void draw() {
  background(smiley ? happyColour : sadColour);
  drawFace(smiley);
  if (frameCount % 100 == 0) {
    smiley = !smiley;
  }
}

void drawFace(boolean smiling) {
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
  strokeWeight(18);
  ellipseMode(CENTER);
  if (smiling) {
    arc(width/2, height/2 - 50, min(width, height), min(width, height), PI/4, 3*PI/4);
  } else {
    arc(width/2, height, min(width, height), min(width, height), PI + PI/4, PI + 3*PI/4);
  }
}

void keyPressed() {
  if (keyCode == UP) {
    offset -= 1;
  } else if (keyCode == DOWN) {
    offset += 1;
  }
  println(offset);
}
