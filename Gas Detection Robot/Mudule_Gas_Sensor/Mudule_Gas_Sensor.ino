#define GAS_IN 7

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  pinMode(GAS_IN, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
   int value = digitalRead(GAS_IN);

   Serial.print("Gas value: ");
   Serial.println(value);

   delay(1000);
}
