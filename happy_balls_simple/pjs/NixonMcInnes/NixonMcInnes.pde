PFont nmFont;
PFont taglineFont;
int happyColour = color(239, 240, 56);
int sadColour = color(176, 210, 235);
int fromColour = happyColour;
int toColour = sadColour;
int happinessCount = 0;
int unhappinessCount = 0;
float lerpAmt = 0.0;
boolean autoLerp = false;

void setup() {
  size(326, 144);
  hint(ENABLE_NATIVE_FONTS);
  nmFont = loadFont("Rockwell Bold");
  taglineFont = loadFont("Cooper Black");
  smooth();
  colorMode(HSB);
}

void draw() {
  background(255);
  fill(lerpColor(fromColour, toColour, lerpAmt));
  textFont(nmFont, 45);
  textAlign(CENTER);
  text("NixonMcInnes", width/2, height/2 - 4);
  fill(155);
  textFont(taglineFont, 22);
  text("Happy Buttons ~\nHow are you feeling?", width/2, height/2 + 28);
  
  if (autoLerp) {
      lerpAmt = abs(sin(radians(frameCount % 360)));
  }
}

void setLerpAmt(float amt) {
  lerpAmt = amt;
}

void incrementCounts(int happinessIncrease, int unhappinessIncrease) {
  happinessCount += happinessIncrease;
  unhappinessCount += unhappinessIncrease;
  int total = happinessCount + unhappinessCount;
  lerpAmt = (float)(unhappinessCount / total);
}

void mouseClicked() {
    lerpAmt = random(1);
}
