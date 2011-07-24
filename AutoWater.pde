/*
  Blink
 Turns on an LED on for one second, then off for one second, repeatedly.
 
 This example code is in the public domain.
 */

int ledPin = 13;
int pumpPin = 10;

// durations in seconds
int pumpPulseDuration = 10;   // seconds pump running every
long pumpDelayDuration = (long)60*60*10; // 12 hours


// informational red blinking delay
int infoDelay = 30; // seconds

int longFlashDuration = 1; // sec
float shortFlashDuration = 0.3; // sec

long timeUntilPumping = 0; // in seconds
long lastPumpingTimestamp = 0;
long timeSinceLastPumping = 0;

int hoursUntilPumping = 0;
int minutesUntilPumping = 0;

void setup()            
{

  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);   // sets the pin as output
  pinMode(pumpPin, OUTPUT);

  delay(3*1000);   // pause a bit before pumping when power on
  Serial.println("Autowater starting...");
    
}

void loop() {
  Serial.print("secondsRunning=");
  Serial.println(millis()/1000);
  
  timeSinceLastPumping = millis()/1000 - lastPumpingTimestamp; // seconds past since the pump ran the last time
    
  Serial.print("Time since last pumping = ");
  Serial.print(timeSinceLastPumping);
  Serial.println(" seconds");


  Serial.print("Pump delay duration = ");
  Serial.print(pumpDelayDuration);
  Serial.println(" seconds");


  timeUntilPumping = (pumpDelayDuration - timeSinceLastPumping); // seconds remaining until the pump runs again

  Serial.print("Time until next pumping = ");
  Serial.print(timeUntilPumping);
  Serial.println(" seconds");

  minutesUntilPumping = (timeUntilPumping%((long)60*60))/60;
  hoursUntilPumping = timeUntilPumping/((long)60*60);
  
  Serial.print("Time left until pumping ");
  Serial.print(hoursUntilPumping); 
  Serial.print(":");
  Serial.println(minutesUntilPumping);


  int tenthsOfMinutes = minutesUntilPumping/10;
  int unitsOfMinutes = minutesUntilPumping%10;
  
  int i;
  for(i = 0; i < hoursUntilPumping; i++) longFlash();
  delay(3000);
  for(i = 0; i < tenthsOfMinutes; i++) shortFlash();
  delay(3000);
  for(i = 0; i < unitsOfMinutes; i++) shortFlash();
  
  
  
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

void shortFlash()
{
  analogWrite(ledPin, 255);
  delay(shortFlashDuration*1000);
  analogWrite(ledPin, 0);
  delay(shortFlashDuration*1000);

}

void longFlash()
{
  analogWrite(ledPin, 255);
  delay(longFlashDuration*1000);
  analogWrite(ledPin, 0);
  delay(shortFlashDuration*1000);
}



