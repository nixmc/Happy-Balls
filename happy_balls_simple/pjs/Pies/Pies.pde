/* @pjs preload="/pjs/Pies/data/dome.png"; */
PImage img;
Pie pie;
List<Pie> pies = new ArrayList<Pie>();
boolean autoUpdate = false;
int offset = 25;

int[][] coords = {
  {77, 61},
  {259, 61},
  {68, 176},
  {175, 260},
  {287, 260}
};

void setup() {
  size(558, 328);
  smooth();
  img = loadImage("/pjs/Pies/data/dome.png");
  for (int i = 0; i < coords.length; i++) {
      pie = new Pie(this, coords[i][0], coords[i][1], 84);
      pie.addSlice(new PieSlice("Happy", 0, color(239, 240, 56, 240)));
      pie.addSlice(new PieSlice("Unhappy", 0, color(176, 210, 235, 240)));
      pies.add(pie);
  }
}

void draw() {
  drawSchematic();
  drawPies();
}

void drawSchematic() {
  background(66);
  fill(255);
  stroke(66);
  strokeWeight(6);
  rect(2, 2, width-6, height-6);
  line(3, (height/3)-50, width-6, (height/3)-50);
  line(3, (2*height/3)+50, width-6, (2*height/3)+50);
  line(62, (height/3)-50, 62, (2*height/3)+50);
  line(171, (height/3)-50, 171, (2*height/3)+50);
  noStroke();
  rect(width - height/2 - 3, 0, height/2 + 3, height);
  stroke(66);
  ellipseMode(CENTER);
  ellipse(width - height/2 - 3, height/2, height-3, height-3);
  imageMode(CENTER);
  image(img, width - height/2 - 3, height/2);
}

void drawPies() {
  for (Pie pie : pies) {
    pie.draw();
  }  
}

void mousePressed() {
  // Grab a random pie, make it pulse
  Pie pie = pies.get(int(random(0, pies.size())));
  pie.pulse();
  PieSlice happySlice = pie.getSliceByLabel("Happy");
  happySlice.setValue(happySlice.getValue() + 5);
}

void keyPressed() {
//  if (keyCode == LEFT) {
//    pie.x -= 1;
//  } else if (keyCode == RIGHT) {
//    pie.x += 1;
//  } else if (keyCode == UP) {
//    pie.y -= 1;
//  } else if (keyCode == DOWN) {
//    pie.y += 1;
//  }
//  
//  println("x: " + pie.x + ", y: " + pie.y);
  if (keyCode == UP) {
    offset++;
  } else if (keyCode == DOWN) {
    offset--;
  }
  
  println(offset);
}

void updatePie(int location, int happiness, int unhappiness) {
    Pie pie = pies.get(location - 1);
    PieSlice happySlice = pie.getSliceByLabel("Happy");
    PieSlice unhappySlice = pie.getSliceByLabel("Unappy");
    happySlice.setValue((float)happiness);
    unhappySlice.setValue((float)unhappiness);
}