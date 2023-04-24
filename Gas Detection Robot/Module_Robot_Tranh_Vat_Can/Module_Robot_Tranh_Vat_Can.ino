/// Define Constant ///
#define FRONT_LEFT_ANODE 5
#define FRONT_LEFT_CATHODE 4
#define FRONT_RIGHT_ANODE 3
#define FRONT_RIGHT_CATHODE 2

#define BEHIND_LEFT_ANODE 9
#define BEHIND_LEFT_CATHODE 8
#define BEHIND_RIGHT_ANODE 6
#define BEHIND_RIGHT_CATHODE 7

// ultrasonic sensor //
#define FRONT_TRIG A0
#define FRONT_ECHO A1
#define LEFT_TRIG A2
#define LEFT_ECHO A3
#define RIGHT_TRIG A4
#define RIGHT_ECHO A5

#define MAX_SPEED 180
#define MIN_SPEED 00
#define MAX_DISTANCE 60.0


/// Define Variable //
float distance_front = 0.0;
float distance_left = 0.0;
float distance_right = 0.0;

// func engine go forward//
void engineGo(int anode, int cathode, int speed) {
  analogWrite(anode, speed);
//  digitalWrite(anode, speed);
  digitalWrite(cathode, LOW);
}

// func motor stop//
void engineStop(int anode, int cathode, int speed) {
  analogWrite(anode, speed);
//  digitalWrite(anode, LOW);
  digitalWrite(cathode, LOW);
}

// robot go straight //
void go_straight(){
  engineGo(FRONT_LEFT_ANODE, FRONT_LEFT_CATHODE, MAX_SPEED);
  engineGo(FRONT_RIGHT_ANODE, FRONT_RIGHT_CATHODE, MAX_SPEED);
  engineGo(BEHIND_LEFT_ANODE, BEHIND_LEFT_CATHODE, MAX_SPEED);
  engineGo(BEHIND_RIGHT_ANODE, BEHIND_RIGHT_CATHODE, MAX_SPEED);
//  delay(500);
}

// robot go left //
void go_left(){
  engineStop(FRONT_LEFT_ANODE, FRONT_LEFT_CATHODE, MIN_SPEED);
  engineGo(FRONT_RIGHT_ANODE, FRONT_RIGHT_CATHODE, MAX_SPEED);
  engineGo(BEHIND_LEFT_ANODE, BEHIND_LEFT_CATHODE, MAX_SPEED);
//  engineStop(BEHIND_LEFT_ANODE, BEHIND_LEFT_CATHODE, MIN_SPEED);
  engineGo(BEHIND_RIGHT_ANODE, BEHIND_RIGHT_CATHODE, MAX_SPEED);
  delay(1000);
}

// robot go right //
void go_right(){
  engineGo(FRONT_LEFT_ANODE, FRONT_LEFT_CATHODE, MAX_SPEED);
  engineStop(FRONT_RIGHT_ANODE, FRONT_RIGHT_CATHODE, MIN_SPEED);
  engineGo(BEHIND_LEFT_ANODE, BEHIND_LEFT_CATHODE, MAX_SPEED);
//  engineStop(BEHIND_RIGHT_ANODE, BEHIND_RIGHT_CATHODE, MIN_SPEED);
  engineGo(BEHIND_RIGHT_ANODE, BEHIND_RIGHT_CATHODE, MAX_SPEED);
  delay(1000);
}

void go_stop(){
  engineStop(FRONT_LEFT_ANODE, FRONT_LEFT_CATHODE, MIN_SPEED);
  engineStop(FRONT_RIGHT_ANODE, FRONT_RIGHT_CATHODE, MIN_SPEED);
  engineStop(BEHIND_LEFT_ANODE, BEHIND_LEFT_CATHODE, MIN_SPEED);
  engineStop(BEHIND_RIGHT_ANODE, BEHIND_RIGHT_CATHODE, MIN_SPEED);
//  delay(400);
}

float calculate_distance(int trig, int echo){
  digitalWrite(trig,0);   // tắt chân trig
  delayMicroseconds(2);
  digitalWrite(trig,1);   // phát xung từ chân trig
  delayMicroseconds(5);   // xung có độ dài 5 microSeconds
  digitalWrite(trig,0);   // tắt chân trig

  /* Tính toán thời gian */
  // Đo độ rộng xung HIGH ở chân echo. 
  int duration = pulseIn(echo, HIGH);  
//  Serial.print("duration = ");
//  Serial.println(duration);
  
  // Tính khoảng cách đến vật.
  return float(0.03432*duration/2);
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  pinMode(FRONT_LEFT_ANODE, OUTPUT);
  pinMode(FRONT_LEFT_CATHODE, OUTPUT);
  pinMode(FRONT_RIGHT_ANODE, OUTPUT);
  pinMode(FRONT_RIGHT_CATHODE, OUTPUT);
  pinMode(BEHIND_LEFT_ANODE, OUTPUT);
  pinMode(BEHIND_LEFT_CATHODE, OUTPUT);
  pinMode(BEHIND_RIGHT_ANODE, OUTPUT);
  pinMode(BEHIND_RIGHT_CATHODE, OUTPUT);

  pinMode(FRONT_TRIG, OUTPUT);
  pinMode(LEFT_TRIG, OUTPUT);
  pinMode(RIGHT_TRIG, OUTPUT);
  
  pinMode(FRONT_ECHO, INPUT);
  pinMode(LEFT_ECHO, INPUT);
  pinMode(RIGHT_ECHO, INPUT);
}

void loop() {
  distance_front = calculate_distance(FRONT_TRIG, FRONT_ECHO);
  delay(100);
//  Serial.print("distance front = ");
//  Serial.println(distance_front);
//  Serial.print("distance left = ");
//  Serial.println(distance_left);
//  Serial.print("distance right = ");
//  Serial.println(distance_right);


  if(distance_front <= MAX_DISTANCE) {
    go_stop();
    delay(100);
//    go_straight();
//    delay(300);
    distance_left = calculate_distance(LEFT_TRIG, LEFT_ECHO);
    delay(50);
    distance_right = calculate_distance(RIGHT_TRIG, RIGHT_ECHO);
    delay(50);
    
    if(distance_right >= distance_left) {
      go_right();
//      go_stop();
    } else {
      go_left();
//      go_stop();
    }

  } else {
    go_straight();

    distance_left = calculate_distance(LEFT_TRIG, LEFT_ECHO);
    distance_right = calculate_distance(RIGHT_TRIG, RIGHT_ECHO);
    
    if(distance_left <= 40.0) {
      go_right();
    } 
    
    if (distance_right <= 40.0){
      go_left();
    }
  }
}
