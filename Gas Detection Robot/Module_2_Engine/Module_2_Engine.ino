
/// Define Constant ///
const int LEFT_PWM = 3;
const int LEFT_OUT = 2;
const int RIGHT_PWM = 5;
const int RIGHT_OUT = 4;

const int MOVE_SPEED = 150;
const int TURN_SPEED = 200;
const int MIN_SPEED = 00;

/// Define Global Variable //

void setup() {
  pinMode(LEFT_PWM, OUTPUT);
  pinMode(LEFT_OUT, OUTPUT);
  pinMode(RIGHT_PWM, OUTPUT);
  pinMode(RIGHT_OUT, OUTPUT);
}


/// Define engine controller functions ///
void move_left(int speed){
  analogWrite(LEFT_PWM, speed);
  digitalWrite(LEFT_OUT, LOW);
}

void move_right(int speed){
  analogWrite(RIGHT_PWM, speed);
  digitalWrite(RIGHT_OUT, LOW);
}

void back_left(int speed){
  analogWrite(LEFT_OUT, speed);
  digitalWrite(LEFT_PWM, LOW);
}

void back_right(int speed){
  analogWrite(RIGHT_OUT, speed);
  digitalWrite(RIGHT_PWM, LOW);
}

/// Define robot controller functions ///
void move_forward(){
  move_left(MOVE_SPEED);
  move_right(MOVE_SPEED);
}

void turn_right(){
  move_right(MIN_SPEED);
  move_left(TURN_SPEED);
}

void turn_left(){
  move_left(MIN_SPEED);
  move_right(TURN_SPEED);
}

void move_back(){
  back_left(MOVE_SPEED);
  back_right(MOVE_SPEED);
}

void stop(){
  move_left(MIN_SPEED);
  move_right(MIN_SPEED);
}


void loop() {
  // put your main code here, to run repeatedly:

   move_forward();
   delay(2000);
   turn_left();
   delay(2000);
   turn_right();
   delay(2000);

  // test //
//  move_right(MOVE_SPEED);
//  delay(3000);
}
