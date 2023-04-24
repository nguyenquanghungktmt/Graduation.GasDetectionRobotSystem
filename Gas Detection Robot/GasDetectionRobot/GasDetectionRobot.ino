#define FRONT_TRIG A0
#define FRONT_ECHO A1
#define LEFT_TRIG A2
#define LEFT_ECHO A3
#define RIGHT_TRIG A4
#define RIGHT_ECHO A5

/// Define Constant ///
const int LEFT_PWM = 5;
const int LEFT_OUT = 4;
const int RIGHT_PWM = 3;
const int RIGHT_OUT = 2;

const int MOVE_SPEED = 150;
const int TURN_SPEED = 255;
const int MIN_SPEED = 00;

const int MIN_DISTANCE = 50.0;



/// Define Global Variable //
int distance_front = 0;
int distance_left = 0;
int distance_right = 0;

void setup() {
  Serial.begin(9600);
  
  pinMode(LEFT_PWM, OUTPUT);
  pinMode(LEFT_OUT, OUTPUT);
  pinMode(RIGHT_PWM, OUTPUT);
  pinMode(RIGHT_OUT, OUTPUT);

  pinMode(FRONT_TRIG, OUTPUT);
  pinMode(LEFT_TRIG, OUTPUT);
  pinMode(RIGHT_TRIG, OUTPUT);
  
  pinMode(FRONT_ECHO, INPUT);
  pinMode(LEFT_ECHO, INPUT);
  pinMode(RIGHT_ECHO, INPUT);
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
  Serial.println("move forwward");
  move_left(MOVE_SPEED);
  move_right(MOVE_SPEED);
}

void turn_right(){
  Serial.println("turn right");
  move_right(MIN_SPEED);
  move_left(TURN_SPEED);
}

void turn_left(){
  Serial.println("turn left");
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


/// function calculate distance ///
int calculate_distance(int trig, int echo){
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
  return int(0.03432*duration/2);
}

void loop() {
    // Ket hop cam bien sieu am //
    distance_front = calculate_distance(FRONT_TRIG, FRONT_ECHO); 
    delay(10);

    // Nếu khoảng cách tới vật cản nhỏ hơn 60cm (có thể đổi số khác)
    if (distance_front <= MIN_DISTANCE){
        // Lập tức dừng xe lại
        stop();
        delay(100); // delay để xe ổn định vị trí

        // đo khoảng cách 2 bên trái và phải
        distance_left = calculate_distance(LEFT_TRIG, LEFT_ECHO);
        delay(10);
        distance_right = calculate_distance(RIGHT_TRIG, RIGHT_ECHO);
        delay(10);

        if (distance_right <= MIN_DISTANCE && distance_left <= MIN_DISTANCE) {
            // đi vào chỗ không có đường đi tiếp ==> lùi xe
            move_back();
            delay(500);
        } 
        else if (distance_right >= distance_left) {
            turn_right();
            delay(800);
        } 
        else {
            turn_left();
            delay(800);
        }

    }
    else{
        move_forward();
    }
}
