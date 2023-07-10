from controller.engines_controller import EnginesController
from controller.ultrasonic_sensors_controller import UltrasonicSensorsController
from controller.gas_sensor_controller import GasSensorController
import RPi.GPIO as GPIO
import time

# Define hằng số
MIN_DISTANCE = 15   # khoang cach gioi han den vat can

# define global variable
robot_controller = EnginesController()
us_sensor_controller = UltrasonicSensorsController()
gas_sensor_controller = GasSensorController()

 
if __name__ == '__main__':

    try:
        print('Start robot ...')
        distance_front = 0

        while True:
            gas_sensor_controller.isGasDetected()
            
            # print('front distance: ', us_sensor_controller.get_front_distance())
            # print('left distance: ', us_sensor_controller.get_left_distance())
            # print('right distance: ', us_sensor_controller.get_right_distance())
            distance_front = us_sensor_controller.get_front_distance()
            time.sleep(0.001)

            if distance_front <= MIN_DISTANCE :
                robot_controller.stop()
                time.sleep(0.1)

                # đo khoảng cách 2 bên
                distance_left = us_sensor_controller.get_left_distance()
                time.sleep(0.001)
                distance_right = us_sensor_controller.get_right_distance()
                time.sleep(0.001)

                if distance_right <= MIN_DISTANCE & distance_left <= MIN_DISTANCE :
                    robot_controller.move_back()
                    time.sleep(0.5)
                elif distance_right >= distance_left :
                    robot_controller.stop_left()
                    robot_controller.turn_right()
                    time.sleep(0.8)
                else :
                    robot_controller.stop_right()
                    robot_controller.turn_left()
                    time.sleep(0.8)

            else :
                robot_controller.move_forward()


            # kich ban test chay robot
            # robot_controller.move_forward()
            # time.sleep(1.5)
            # robot_controller.turn_left()
            # time.sleep(1.5)
            # robot_controller.turn_right()
            # time.sleep(1.5)
            # robot_controller.stop()
            # time.sleep(1.5)

    finally:
        print("============================")
        print("Crash Robot")
        GPIO.cleanup()