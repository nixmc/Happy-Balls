List<Lamp> lamps = new ArrayList<Lamp>();

void setup() {
  size(1280, 800);
  smooth();
}

void draw() {
  background(0);
  for (Lamp lamp : lamps)
    lamp.draw();
  Lamp l = new Lamp(this, mouseX, mouseY, 350);
  l.pulse(color(random(0,255), random(0,255), random(0,255)));
  lamps.add(l);
}

void mousePressed() {
  Lamp l = new Lamp(this, mouseX, mouseY, 50);
  l.pulse(color(random(0,255), random(0,255), random(0,255)));
  lamps.add(l);
}

void keyPressed() {
  if (keyCode == ' ') {
    lamps.clear();
  }
}
