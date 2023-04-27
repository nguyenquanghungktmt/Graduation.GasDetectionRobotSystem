import time
from engines_controller import EnginesController
from ultrasonic_sensors_controller import UltrasonicSensorsController
import RPi.GPIO as GPIO

# define global variable
robot_controller = EnginesController()
us_sensor_controller = UltrasonicSensorsController()

 
if __name__ == '__main__':

    # try:
    #     while True:
    print('Start robot ...')
    # print('front distance: ', us_sensor_controller.get_front_distance())
    # print('left distance: ', us_sensor_controller.get_left_distance())
    # print('right distance: ', us_sensor_controller.get_right_distance())

    robot_controller.move_forward()
    time.sleep(1.5)
    robot_controller.turn_left()
    time.sleep(1.5)
    robot_controller.turn_right()
    time.sleep(1.5)
    robot_controller.stop()
    time.sleep(1.5)
    # robot_controller.move_forward()
    # time.sleep(1.5)

    GPIO.cleanup()
    # finally:
    #     print("Have bug")