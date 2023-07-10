import RPi.GPIO as GPIO

# Define hằng số
MOVE_SPEED = 40
TURN_SPEED = 60
MIN_SPEED = 0
 
class EnginesController(object):
    """
    class used to control the engines to move or stop the robot

    Attributes
    ----------
    left_pwm : int
        number of left pwm pin
    left_out : int
        number of left out pin
    right_pwm : int
        number of right pwm pin
    right_out : int
        number of right out pin

    Methods
    -------
    
    """

 
    def __init__(self, left_pwm=12, left_out=16, right_pwm=13, right_out=19):
        self.left_pwm = left_pwm
        self.left_out = left_out
        self.right_pwm = right_pwm
        self.right_out = right_out

        self.move_speed = MOVE_SPEED
        self.turn_speed = TURN_SPEED
 
 
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)

        GPIO.setup(self.left_pwm,GPIO.OUT)
        GPIO.setup(self.left_out,GPIO.OUT)
        GPIO.setup(self.right_pwm,GPIO.OUT)
        GPIO.setup(self.right_out,GPIO.OUT)
 
        # self.stop()

        self.PWMA = GPIO.PWM(self.left_pwm, 500)
        self.PWMB = GPIO.PWM(self.right_pwm, 500)
        self.PWMA.start(0)
        self.PWMB.start(0)

        self.stop()


    def setPWM_left(self, value):
        self.PWMA.ChangeDutyCycle(value)
 
    def setPWM_right(self, value):
        self.PWMB.ChangeDutyCycle(value)  
 
    # Define engine controller functions
    def move_left(self, speed):
        self.setPWM_left(speed)
        # GPIO.output(self.left_pwm, GPIO.HIGH)
        GPIO.output(self.left_out, GPIO.LOW)
    

    def move_right(self, speed):
        self.setPWM_right(speed)
        # GPIO.output(self.right_pwm, GPIO.HIGH)
        GPIO.output(self.right_out, GPIO.LOW)

    def stop_left(self):
        GPIO.output(self.left_pwm, GPIO.LOW)
        GPIO.output(self.left_out, GPIO.LOW)
    

    def stop_right(self):
        GPIO.output(self.right_pwm, GPIO.LOW)
        GPIO.output(self.right_out, GPIO.LOW)
    

    def back_left(self, speed):
        GPIO.output(self.left_out, GPIO.HIGH)
        GPIO.output(self.left_pwm, GPIO.LOW)


    def back_right(self, speed):
        GPIO.output(self.right_out, GPIO.HIGH)
        GPIO.output(self.right_pwm, GPIO.LOW)


    # Define robot controller functions 
    def move_forward(self):
        # print("move forwward")
        self.move_left(self.move_speed)
        self.move_right(self.move_speed)
    

    def turn_right(self):
        # print("turn right")
        self.move_right(MIN_SPEED)
        self.move_left(self.turn_speed)
    

    def turn_left(self):
        # print("turn left")
        self.move_left(MIN_SPEED)
        self.move_right(self.turn_speed)
    

    def move_back(self):
        self.back_left(self.move_speed)
        self.back_right(self.move_speed)
    

    def stop(self):
        # print('stop')
        self.stop_left()
        self.stop_right()

    def set_speed_up(self):
        self.move_speed += 5
        self.turn_speed += 5

    def set_speed_down(self):
        self.move_speed -= 5
        self.turn_speed -= 5
