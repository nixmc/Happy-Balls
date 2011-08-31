import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Pies extends PApplet {

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

public void setup() {
  size(558, 328);
  smooth();
  img = loadImage("dome.png");
  for (int i = 0; i < coords.length; i++) {
      pie = new Pie(this, coords[i][0], coords[i][1], 84);
      int value = PApplet.parseInt(random(0, 100));
      pie.addSlice(new PieSlice("Happy", value, color(239, 240, 56, 240)));
      pie.addSlice(new PieSlice("Unhappy", 100 - value, color(176, 210, 235, 240)));
      pies.add(pie);
  }
}

public void draw() {
  drawSchematic();
  drawPies();
}

public void drawSchematic() {
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

public void drawPies() {
  for (Pie pie : pies) {
    pie.draw();
  }  
}

public void mousePressed() {
  // Grab a random pie, make it pulse
  Pie pie = pies.get(PApplet.parseInt(random(0, pies.size())));
  pie.pulse();
  PieSlice happySlice = pie.getSliceByLabel("Happy");
  happySlice.setValue(happySlice.getValue() + 5);
}

public void keyPressed() {
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
class Pie {
  PApplet parent;
  int x;
  int y;
  int r;
  float origin = -PI/2;
  boolean pulsing = false;
  float rInc = 0;
  int baseFrame = 0;
  int pulseCount = 0;
  List<PieSlice> slices = new ArrayList<PieSlice>();
  
  Pie(PApplet parent, int xPos, int yPos, int radius) {
//    println("Making a pie");
    this.parent = parent;
    this.x = xPos;
    this.y = yPos;
    this.r = radius;
  }
  
  public void addSlice(PieSlice slice) {
    println(slice.label + ": " + slice.getValue());
    slices.add(slice);
  }
  
  public PieSlice getSliceByLabel(String label) {
    for (PieSlice slice : slices) {
      if (slice.label.equals(label)) {
        return slice;
      }
    }
    return null;
  }
  
  public void pulse() {
    this.pulsing = true;
    this.baseFrame = parent.frameCount;
  }
  
  public void draw() {    
    // Sum all the slices to arrive at total
    float total = 0;
    for (PieSlice slice : slices) {
      total += slice.getValue();
    }
    
    // Draw the pie
    parent.noStroke();
    parent.ellipseMode(CENTER);
    float start = origin;
    for (PieSlice slice : slices) {
      // What proportion of the pie is consumed by this slice?
      float proportion = slice.getValue() / total;
      
      // Expressed in radians...
      float proportionRadians = proportion * 2 * PI;
      
      // Draw the slice
      parent.fill(slice.getColor());
      parent.arc(this.x, this.y, this.r + this.rInc, this.r + this.rInc, start, start + proportionRadians);
      
      // Update start position for next slice
      start += proportionRadians;
    }
    
    if (pulsing) {
      this.pulseCount = (parent.frameCount - this.baseFrame) % 360;
      this.rInc = this.r * parent.abs(parent.sin(parent.radians(this.pulseCount)));
      if (this.pulseCount == 180) {
        this.pulsing = false;
        this.rInc = 0;
      }
    }
  }
}
class PieSlice {
  String label;
  float v;
  int c;
  
  PieSlice(String label, float value, int clr) {
    this.label = label;
    this.v = value;
    this.c = clr;
  }
  
  public void setValue(float value) {
    this.v = value;
  }
  
  public float getValue() {
    return this.v;
  }
  
  public int getColor() {
    return this.c;
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--hide-stop", "Pies" });
  }
}
