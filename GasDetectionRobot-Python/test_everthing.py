from engines_controller import EnginesController
from ultrasonic_sensors_controller import UltrasonicSensorsController
from gas_sensor_controller import GasSensorController
import RPi.GPIO as GPIO
import time

# Define hằng số
MIN_DISTANCE = 15   # khoang cach gioi han den vat can

# define global variable
robot_controller = EnginesController()
us_sensor_controller = UltrasonicSensorsController()
gar_sensor_controller = GasSensorController()

 
if __name__ == '__main__':

    try:
        print('Start robot ...')

        while True:

            # Test cam bien khoang cach
            # print('front distance: ', us_sensor_controller.get_front_distance())
            # print('left distance: ', us_sensor_controller.get_left_distance())
            # print('right distance: ', us_sensor_controller.get_right_distance())


            # kich ban test chay robot
            # robot_controller.move_forward()
            # time.sleep(1.5)
            # robot_controller.turn_left()
            # time.sleep(1.5)
            # robot_controller.turn_right()
            # time.sleep(1.5)
            # robot_controller.stop()
            # time.sleep(1.5)

            # test cam bien khi ga
            gar_sensor_controller.isGasDetected()

    finally:
        print("============================")
        print("Crash Robot")
        GPIO.cleanup()