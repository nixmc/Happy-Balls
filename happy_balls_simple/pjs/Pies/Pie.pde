class Pie {
  PApplet parent;
  int x;
  int y;
  int r;
  float origin = -PI/2;
  boolean pulsing = false;
  float rOffset = 0;
  float originOffset = 0;
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
  
  void addSlice(PieSlice slice) {
    // println(slice.label + ": " + slice.getValue());
    slices.add(slice);
  }
  
  PieSlice getSliceByLabel(String label) {
    for (PieSlice slice : slices) {
      if (slice.label.equals(label)) {
        return slice;
      }
    }
    return null;
  }
  
  void pulse() {
    this.pulsing = true;
    this.baseFrame = parent.frameCount;
  }
  
  void draw() {
    // How many slices are there?
    float numSlices = (float)slices.size();
    
    // Sum all the slices to arrive at total
    float total = 0;
    for (PieSlice slice : slices) {
      total += slice.getValue();
    }
    
    // Draw the pie
    parent.noStroke();
    parent.ellipseMode(CENTER);
    float start = origin + this.originOffset;
    for (PieSlice slice : slices) {
      // What proportion of the pie is consumed by this slice?
      float proportion = total == 0.0 ? 1.0 / numSlices : slice.getValue() / total;
      
      // Expressed in radians...
      float proportionRadians = proportion * 2 * PI;
      
      // Draw the slice
      parent.fill(slice.getColor());
      parent.arc(this.x, this.y, this.r + this.rOffset, this.r + this.rOffset, start, start + proportionRadians);
      
      // Update start position for next slice
      start += proportionRadians;
    }
    
    if (pulsing) {
      this.pulseCount = (parent.frameCount - this.baseFrame) % 360;
      float offset = parent.abs(parent.sin(parent.radians(this.pulseCount)));
      this.rOffset = this.r * offset;
      this.originOffset = this.origin/3 * offset;
      if (this.pulseCount == 180) {
        this.pulsing = false;
        this.rOffset = 0;
        this.originOffset = 0;
      }
    }
  }
}
