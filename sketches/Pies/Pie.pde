class Pie {
  PApplet parent;
  int x;
  int y;
  int r;
  float origin = -PI/2;
  
  List<PieSlice> slices = new ArrayList<PieSlice>();
  
  Pie(PApplet parent, int xPos, int yPos, int radius) {
//    println("Making a pie");
    this.parent = parent;
    this.x = xPos;
    this.y = yPos;
    this.r = radius;
  }
  
  void addSlice(PieSlice slice) {
    println(slice.label + ": " + slice.getValue());
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
  
  void draw() {    
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
      parent.arc(this.x, this.y, this.r, this.r, start, start + proportionRadians);
      
      // Update start position for next slice
      start += proportionRadians;
    }
  }
}
