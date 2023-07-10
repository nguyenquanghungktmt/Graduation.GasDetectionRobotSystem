import RPi.GPIO as GPIO
import time
 
class UltrasonicSensorsController(object):
    """
    class used to control the ultrasonic sensors

    Attributes
    ----------
    front_trig : int
        number of trigger pin defined for front sensor
    front_echo : int
        number of echo pin defined for front sensor
    leftt_trig : int
        number of trigger pin defined for left sensor
    left_echo : int
        number of echo pin defined for left sensor
    right_trig : int
        number of trigger pin defined for right sensor
    right_echo : int
        number of echo pin defined for right sensor

    Methods
    -------
    calculate_distance:
        calculate the distance from sensor to object
    get_front_distance:
        get distance from front sensor to object
    get_left_distance:
        get distance from left sensor to object
    get_right_distance:
        get distance from right sensor to object
    """

    def __init__(self, front_trig=5, front_echo=6, left_trig=22, left_echo=27, right_trig=23, right_echo=24):
        self.front_trig = front_trig
        self.front_echo = front_echo
        self.left_trig = left_trig
        self.left_echo = left_echo
        self.right_trig = right_trig
        self.right_echo = right_echo

        GPIO.setmode(GPIO.BCM)

        GPIO.setup(self.front_trig,GPIO.OUT)  # Trigger
        GPIO.setup(self.front_echo,GPIO.IN)   # Echo
        GPIO.setup(self.left_trig,GPIO.OUT)  # Trigger
        GPIO.setup(self.left_echo,GPIO.IN)   # Echo
        GPIO.setup(self.right_trig,GPIO.OUT)  # Trigger
        GPIO.setup(self.right_echo,GPIO.IN)   # Echo

        GPIO.output(self.front_trig, False)
        GPIO.output(self.left_trig, False)
        GPIO.output(self.right_trig, False)
        time.sleep(0.5)

    # function calculate distanc from sensor to barrier
    def calculate_distance(self, trigger, echo):
        """ calculate distance from ultrasonic sensor HC04 to object
    
        Parameters
        ----------
        self: this object
        trigger: int
            Number of trigger pin
        echo: int
            Number of echo pin
    
        Returns
        -------
        int
            Number of distance 
        """

        # Kích hoạt cảm biến bằng cách ta nháy cho nó tí điện rồi ngắt đi luôn.
        GPIO.output(trigger, True)
        time.sleep(0.00001)
        GPIO.output(trigger, False)

        # Đánh dấu thời điểm bắt đầu
        start = time.time()
        while GPIO.input(echo) == 0:
            start = time.time()

        # Bắt thời điểm nhận được tín hiệu từ Echo
        stop = 0
        while GPIO.input(echo)==1:
            stop = time.time()

        # Thời gian từ lúc gửi tín hiêu
        elapsed = stop-start

        # Distance pulse travelled in that time is time
        # multiplied by the speed of sound (cm/s)
        distance = elapsed * 34300 / 2

        # print("Distance : %.1f" % distance)
        return int(distance)
    
    def get_front_distance(self):
        return self.calculate_distance(self.front_trig, self.front_echo)
    
    def get_left_distance(self):
        return self.calculate_distance(self.left_trig, self.left_echo)
    
    def get_right_distance(self):
        return self.calculate_distance(self.right_trig, self.right_echo)

    