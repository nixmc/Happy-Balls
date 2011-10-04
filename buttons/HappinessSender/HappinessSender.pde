#define FDMAX 255

#include <VirtualWire.h>
#include <EEPROM.h> //Needed to access the eeprom read write functions
#include <Bounce.h> //Digital input debouncing

#define happyLoc 0
#define sadLoc 2
#define happyPin 1
#define sadPin 2 // WAS 3

#define sadGreen 7
#define sadBlue 8
#define sadRed 6
#define happyGreen 10
#define happyBlue 11
#define happyRed 9

#define uintMax 65535

#define location 1

#define vccPin 13
#define txPin 12

#undef int
#undef abs
#undef double
#undef float
#undef round

unsigned int happy;
unsigned int sad;

Bounce happyBouncer = Bounce(happyPin, 400);
Bounce sadBouncer = Bounce(sadPin, 400);

void setup()
{
  pinMode(happyRed, OUTPUT);
  pinMode(happyGreen, OUTPUT);
  pinMode(happyBlue, OUTPUT);
  pinMode(sadRed, OUTPUT);
  pinMode(sadGreen, OUTPUT);
  pinMode(sadBlue, OUTPUT);
  
  //Serial.begin(9600);

  //Transmitter setup
  vw_set_tx_pin(txPin);
  vw_setup(1000);	 // Bits per sec
  pinMode(vccPin, OUTPUT);
  digitalWrite(vccPin, HIGH);

  happy = EEPROMReadInt(happyLoc);
  if(happy == uintMax)
    happy = 0;    
  sad = EEPROMReadInt(sadLoc);
  if(sad == uintMax)
    sad = 0;
    
  //seed the random number gen so we don't clash  
  randomSeed(analogRead(0));
  
  pinMode(happyPin, INPUT);
  digitalWrite(happyPin, HIGH);
  
  pinMode(sadPin, INPUT);
  digitalWrite(sadPin, HIGH);
  
  // Startup colors
  digitalWrite(happyRed, HIGH);
  digitalWrite(sadRed, HIGH);
  delay(1000);
  digitalWrite(happyRed, LOW);
  digitalWrite(sadRed, LOW);
  digitalWrite(happyGreen, HIGH);
  digitalWrite(sadGreen, HIGH);
  delay(1000);
  digitalWrite(happyGreen, LOW);
  digitalWrite(sadGreen, LOW);
  digitalWrite(happyBlue, HIGH);
  digitalWrite(sadBlue, HIGH);
  delay(1000);
  digitalWrite(happyBlue, LOW);
  digitalWrite(sadBlue, LOW);
  delay(1000);
  
}

void loop() {
  
  readButtons();
  sendValues();
  
  digitalWrite(happyRed, HIGH);
  digitalWrite(happyGreen, HIGH);
  digitalWrite(sadBlue, HIGH);
  
}

void readButtons(){
  happyBouncer.update();
  sadBouncer.update();

  //if(happyBouncer.risingEdge() || happyBouncer.fallingEdge()){
  if(happyBouncer.risingEdge()){
    happy++;
    EEPROMWriteInt(happyLoc, happy);
    
    sendValues();
    
    digitalWrite(happyRed, LOW);
    digitalWrite(happyGreen, LOW);
    digitalWrite(happyBlue, LOW);
    digitalWrite(sadRed, LOW);
    digitalWrite(sadGreen, LOW);
    digitalWrite(sadBlue, LOW);
    
    for (int t = 0; t < 8; t++) {
      digitalWrite(happyRed, HIGH);
      digitalWrite(happyGreen, HIGH);
      delay(200);
      digitalWrite(happyRed, LOW);
      digitalWrite(happyGreen, LOW);
      delay(200);
    }
    
    //Serial.print("happy++ ");
    //Serial.println(happy);
  }
  if(sadBouncer.risingEdge()){
    sad++;
    EEPROMWriteInt(sadLoc, sad);
    
    sendValues();
    
    digitalWrite(happyRed, LOW);
    digitalWrite(happyGreen, LOW);
    digitalWrite(happyBlue, LOW);
    digitalWrite(sadRed, LOW);
    digitalWrite(sadGreen, LOW);
    digitalWrite(sadBlue, LOW);
    
    for (int t = 0; t < 8; t++) {
      digitalWrite(sadBlue, HIGH);
      delay(200);
      digitalWrite(sadBlue, LOW);
      delay(200);
    }
    
    //Serial.print("sad++ ");
    //Serial.println(sad);
  }
}


unsigned long previousMillis = 0;
unsigned long millisBetweenSends = 0; //send on startup
void sendValues(){
  unsigned long currentMillis = millis();
  if(currentMillis - previousMillis > millisBetweenSends) {
    previousMillis = currentMillis;
    millisBetweenSends = random(5000, 10000); //between 5 and 10 seconds
    //millisBetweenSends = 1000;
      //Serial.print("Location: ");
      //Serial.print(location);
      //Serial.print(" happy: ");
      //Serial.print(happy);
      //Serial.print(" sad: ");
      //Serial.println(sad);
    
    uint8_t packet[] = {(uint8_t)location, (uint8_t)happy, (uint8_t)(happy >> 8), (uint8_t)sad, (uint8_t)(sad >> 8)};
    vw_send(packet, 5);
    vw_wait_tx(); // Wait until the whole message is gone
  }
}

//This function will write a 2 byte integer to the eeprom at the specified address and address + 1
void EEPROMWriteInt(int p_address, int p_value)
{
  byte lowByte = ((p_value >> 0) & 0xFF);
  byte highByte = ((p_value >> 8) & 0xFF);

  EEPROM.write(p_address, lowByte);
  EEPROM.write(p_address + 1, highByte);
}

//This function will read a 2 byte integer from the eeprom at the specified address and address + 1
unsigned int EEPROMReadInt(int p_address)
{
  byte lowByte = EEPROM.read(p_address);
  byte highByte = EEPROM.read(p_address + 1);

  return ((lowByte << 0) & 0xFF) + ((highByte << 8) & 0xFF00);
}
