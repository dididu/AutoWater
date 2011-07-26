/*
 Autowater
 Runs the pump for automated plant watering system 
 Blinking LED on Arduino represents the countdown till the next run
 */

int ledPin = 13;
int pumpPin = 10;

// durations in seconds
int pumpPulseDuration = 10;   // seconds pump running every
unsigned long pumpDelayDuration = (unsigned long)60*60*12; // 12 hours

// informational red blinking delay
int infoDelay = 20; // seconds

int longFlashDuration = 1; // sec
float shortFlashDuration = 0.3; // sec
float veryShortFlashDuration = 0.1; // sec

unsigned long timeUntilPumping = 0; // in seconds
unsigned long lastPumpingTimestamp = 0;
unsigned long timeSinceLastPumping = 0;

void setup()            
{
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);   // sets the pin as output
  pinMode(pumpPin, OUTPUT);

  delay(3*1000);   // pause a bit before starting
  Serial.println("Autowater starting...");
}

void loop() {
  Serial.print("secondsRunning=");
  Serial.println(millis()/1000);

  timeSinceLastPumping = millis()/1000 - lastPumpingTimestamp; // seconds past since the pump ran the last time

  Serial.print("Time since last pumping = ");
  Serial.print(timeSinceLastPumping);
  Serial.println(" seconds");

  timeUntilPumping = (pumpDelayDuration - timeSinceLastPumping); // seconds remaining until the pump runs again

  Serial.print("Time until next pumping = ");
  Serial.print(timeUntilPumping);
  Serial.println(" seconds");
  
  blinkRemainingTime();
  
  if( timeUntilPumping < infoDelay*2 ) doPumping();  

  Serial.println();
  delay(infoDelay*1000);
}

void doPumping()
{
  Serial.println("PUMPING!");

  analogWrite(ledPin, 255);
  analogWrite(pumpPin, 255);

  delay(pumpPulseDuration*1000);  

  analogWrite(ledPin, 0);
  analogWrite(pumpPin, 0);  

  lastPumpingTimestamp = millis()/1000;
  Serial.println("PUMPING DONE!");
}

// LED flashing utilities

void blinkRemainingTime()
{
  int hoursUntilPumping;
  int minutesUntilPumping;
  int tenthsOfMinutes;
  int unitsOfMinutes;

  hoursUntilPumping = timeUntilPumping/((long)60*60);
  minutesUntilPumping = (timeUntilPumping%(60*60))/60;
  tenthsOfMinutes = minutesUntilPumping/10;
  unitsOfMinutes = minutesUntilPumping%10;

  Serial.print("Time left until pumping ");
  Serial.print(hoursUntilPumping); 
  Serial.print(":");
  Serial.println(minutesUntilPumping);

  int i;
  for(i = 0; i < hoursUntilPumping; i++) longFlash();
  delay(3000);
  for(i = 0; i < tenthsOfMinutes; i++) shortFlash();
  delay(3000);
  for(i = 0; i < unitsOfMinutes; i++) veryShortFlash();
}

void longFlash()
{
  analogWrite(ledPin, 255);
  delay(longFlashDuration*1000);
  analogWrite(ledPin, 0);
  delay(shortFlashDuration*1000);
}

void shortFlash()
{
  analogWrite(ledPin, 255);
  delay(shortFlashDuration*1000);
  analogWrite(ledPin, 0);
  delay(shortFlashDuration*1000);
}

void veryShortFlash()
{
  analogWrite(ledPin, 255);
  delay(veryShortFlashDuration*1000);
  analogWrite(ledPin, 0);
  delay(shortFlashDuration*1000);
}

