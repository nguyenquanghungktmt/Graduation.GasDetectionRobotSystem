import RPi.GPIO as GPIO
import time
 
class GasSensorController(object):
    """
    class used to control gas sensor, check gas leak

    Attributes
    ----------
    digital_in : int
        number of input pin

    Methods
    -------
    isGasDetected:
        check gas leak
    
    """

    def __init__(self, digital_in=26):
        self.digital_in = digital_in

        GPIO.setmode(GPIO.BCM)

        GPIO.setup(self.digital_in, GPIO.IN)  
        time.sleep(0.05)

    
    def isGasDetected(self):
        """ Check sensor detect gas leak
    
        Parameters
        ----------
        self: this object
    
        Returns
        -------
        bool
            True if gas leak and False if not
        """
        value = GPIO.input(self.digital_in)
        print('value = ', value)
        return value == 0
    

    