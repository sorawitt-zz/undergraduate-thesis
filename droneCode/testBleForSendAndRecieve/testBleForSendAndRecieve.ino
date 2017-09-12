boolean isReady = true;
char incomingByte = ' ';

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  
  if (Serial.available() > 0) {
    
    // read the incoming byte:
    incomingByte = Serial.read();
    if (incomingByte = 'f') {
      digitalWrite(LED_BUILTIN, 1);
      doSomeThing();
      droneReady();
    }
  }

}

void doSomeThing(){
  delay(3000);
}

void droneReady(){
  Serial.print("Ready");
}

