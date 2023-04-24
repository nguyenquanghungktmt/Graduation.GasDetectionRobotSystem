/// Define Constant ///
#define FRONT_LEFT_ANODE 5
#define FRONT_LEFT_CATHODE 4
#define FRONT_RIGHT_ANODE 3
#define FRONT_RIGHT_CATHODE 2

#define BEHIND_LEFT_ANODE 9
#define BEHIND_LEFT_CATHODE 8
#define BEHIND_RIGHT_ANODE 6
#define BEHIND_RIGHT_CATHODE 7

#define MAX_SPEED 200
#define MIN_SPEED 00


/// Define Variable //

void setup() {
  // put your setup code here, to run once:
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);


  pinMode(FRONT_LEFT_ANODE, OUTPUT);
  pinMode(FRONT_LEFT_CATHODE, OUTPUT);
  pinMode(FRONT_RIGHT_ANODE, OUTPUT);
  pinMode(FRONT_RIGHT_CATHODE, OUTPUT);
  pinMode(BEHIND_LEFT_ANODE, OUTPUT);
  pinMode(BEHIND_LEFT_CATHODE, OUTPUT);
  pinMode(BEHIND_RIGHT_ANODE, OUTPUT);
  pinMode(BEHIND_RIGHT_CATHODE, OUTPUT);

  pinMode(LED_BUILTIN, OUTPUT);
}


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
  digitalWrite(LED_BUILTIN, LOW);
  engineGo(FRONT_LEFT_ANODE, FRONT_LEFT_CATHODE, MAX_SPEED);
  engineGo(FRONT_RIGHT_ANODE, FRONT_RIGHT_CATHODE, MAX_SPEED);
  engineGo(BEHIND_LEFT_ANODE, BEHIND_LEFT_CATHODE, MAX_SPEED);
  engineGo(BEHIND_RIGHT_ANODE, BEHIND_RIGHT_CATHODE, MAX_SPEED);
  delay(2000);
}

// robot go left //
void go_left(){
  engineStop(FRONT_LEFT_ANODE, FRONT_LEFT_CATHODE, MIN_SPEED);
  engineGo(FRONT_RIGHT_ANODE, FRONT_RIGHT_CATHODE, MAX_SPEED);
  engineStop(BEHIND_LEFT_ANODE, BEHIND_LEFT_CATHODE, MIN_SPEED);
  engineGo(BEHIND_RIGHT_ANODE, BEHIND_RIGHT_CATHODE, MAX_SPEED);
  delay(2500);
//  go_straight();
}

// robot go right //
void go_right(){
  digitalWrite(LED_BUILTIN, HIGH);
  engineGo(FRONT_LEFT_ANODE, FRONT_LEFT_CATHODE, MAX_SPEED);
  engineStop(FRONT_RIGHT_ANODE, FRONT_RIGHT_CATHODE, MIN_SPEED);
  engineGo(BEHIND_LEFT_ANODE, BEHIND_LEFT_CATHODE, MAX_SPEED);
  engineStop(BEHIND_RIGHT_ANODE, BEHIND_RIGHT_CATHODE, MIN_SPEED);
  delay(2500);
//  go_straight();
}


// robot go right //
void go_stop(){
  engineStop(FRONT_LEFT_ANODE, FRONT_LEFT_CATHODE, MIN_SPEED);
  engineStop(FRONT_RIGHT_ANODE, FRONT_RIGHT_CATHODE, MIN_SPEED);
  engineStop(BEHIND_LEFT_ANODE, BEHIND_LEFT_CATHODE, MIN_SPEED);
  engineStop(BEHIND_RIGHT_ANODE, BEHIND_RIGHT_CATHODE, MIN_SPEED);
  delay(400);
}
void engine_front_left_go(){
  
}

void loop() {
//  Serial.println("Hungnq");
  go_straight();

  go_right();

//  go_stop();
//  delay(10000);
}
