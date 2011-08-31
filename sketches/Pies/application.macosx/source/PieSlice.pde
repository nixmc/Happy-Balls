class PieSlice {
  String label;
  float v;
  int c;
  
  PieSlice(String label, float value, int clr) {
    this.label = label;
    this.v = value;
    this.c = clr;
  }
  
  void setValue(float value) {
    this.v = value;
  }
  
  float getValue() {
    return this.v;
  }
  
  int getColor() {
    return this.c;
  }
}
