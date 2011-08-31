class Lamp {
  
  PApplet parent;
  int x;
  int y;
  int r;
  int on;
  int off;
  float alpha = 0;
  boolean pulsing = false;
  int baseFrame = 0;
  int count = 0;
  int cycles = 0;
  
  Lamp(PApplet parent, int xPos, int yPos, int radius) {
    println("Making a lamp");
    this.parent = parent;
    this.x = xPos;
    this.y = yPos;
    this.r = radius;
    this.off = color(255);
  }
  
  void pulse(int targetColour) {
    this.on = targetColour;
    pulsing = true;
    baseFrame = parent.frameCount;
  }
  
  void draw() {
    if (!pulsing) return;
    
    // Draw the lamp
    parent.noStroke();
    parent.ellipseMode(CENTER);
    parent.fill(this.off);
    parent.ellipse(this.x, this.y, this.r, this.r);
    parent.fill(parent.red(this.on), parent.blue(this.on), parent.green(this.on), this.alpha);
    parent.ellipse(this.x, this.y, this.r, this.r);
    
    // Adjust the alpha, gradually making the lamp more opaque;
    // Plot the alpha value along a sine wave, so it fades in/out nicely
    this.count = (parent.frameCount - this.baseFrame) % 360;
    this.alpha = 255 * parent.abs(parent.sin(parent.radians(this.count)));
    if (this.count == 180) {
      this.pulsing = false;
    }    
  }
}
