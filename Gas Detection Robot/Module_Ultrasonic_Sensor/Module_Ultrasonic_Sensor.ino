/// Define constant ///
#define FRONT_TRIG A0
#define FRONT_ECHO A1
#define LEFT_TRIG A2
#define LEFT_ECHO A3
#define RIGHT_TRIG A4
#define RIGHT_ECHO A5

float calculate_distance(int trig, int echo){
  digitalWrite(trig,0);   // tắt chân trig
  delayMicroseconds(2);
  digitalWrite(trig,1);   // phát xung từ chân trig
  delayMicroseconds(5);   // xung có độ dài 5 microSeconds
  digitalWrite(trig,0);   // tắt chân trig

  /* Tính toán thời gian */
  // Đo độ rộng xung HIGH ở chân echo. 
  int duration = pulseIn(echo, HIGH);  
  Serial.print("duration = ");
  Serial.println(duration);
  
  // Tính khoảng cách đến vật.
  return float(0.03432*duration/2);
}


// dự phòng //
long GetDistance(int trig, int echo) {
  long duration, distanceCm;
   
  digitalWrite(trig, LOW);
  delayMicroseconds(2);
  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);
  
  duration = pulseIn(echo, HIGH);
  Serial.print("duration = ");
  Serial.println(duration);

  // convert to distance
  distanceCm = long(duration / 29.1 / 2);
  
  return distanceCm;
}
// end //

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  pinMode(FRONT_TRIG, OUTPUT);
  pinMode(LEFT_TRIG, OUTPUT);
  pinMode(RIGHT_TRIG, OUTPUT);
  
  pinMode(FRONT_ECHO, INPUT);
  pinMode(LEFT_ECHO, INPUT);
  pinMode(RIGHT_ECHO, INPUT);
}

void loop() {
  float distance_front = calculate_distance(FRONT_TRIG, FRONT_ECHO);
  float distance_left = calculate_distance(LEFT_TRIG, LEFT_ECHO);
  float distance_right = calculate_distance(RIGHT_TRIG, RIGHT_ECHO);
  Serial.print("distance front = ");
  Serial.println(distance_front);
  Serial.print("distance left = ");
  Serial.println(distance_left);
  Serial.print("distance right = ");
  Serial.println(distance_right);

  delay(1000);
}
