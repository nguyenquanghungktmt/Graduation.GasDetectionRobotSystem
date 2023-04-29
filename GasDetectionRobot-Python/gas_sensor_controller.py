import RPi.GPIO as GPIO
import time
 
class GasSensorController(object):

    def __init__(self, digital_in=26):
        self.digital_in = digital_in

        GPIO.setmode(GPIO.BCM)

        GPIO.setup(self.digital_in, GPIO.IN)  
        time.sleep(0.05)

    # function check has gas leak
    def isGasDetected(self):
        value = GPIO.input(self.digital_in)
        print('value = ', value)
        return value == 0
    

    