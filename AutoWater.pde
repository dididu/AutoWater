/*
  Blink
 Turns on an LED on for one second, then off for one second, repeatedly.
 
 This example code is in the public domain.
 */

int ledPin = 13;
int pumpPin = 10;

// durations in seconds
int pumpPulseDuration = 10;   // 15 seconds pump running every
unsigned long delayDuration = 60*60*12; // 12 hours

void setup()            
{
  pinMode(ledPin, OUTPUT);   // sets the pin as output
  pinMode(pumpPin, OUTPUT);

  delay(10*1000);   // pause a bit before pumping when power on
}

void loop() {
  analogWrite(ledPin, 255);
  analogWrite(pumpPin, 255);

  delay(pumpPulseDuration*1000);  
  analogWrite(ledPin, 0);
  analogWrite(pumpPin, 0);

  delay(delayDuration*1000);  
}

