from engines_controller import EnginesController
from ultrasonic_sensors_controller import UltrasonicSensorsController
from gas_sensor_controller import GasSensorController
from network_utils import NetworkUtils
from azure_hub_utils import AzureIoTHubUtils
from command_direct_utils import CommandDirectUtils
from command_enum import Command

# import RPi.GPIO as GPIO
import time
import random
import asyncio

# Define hằng số
MIN_DISTANCE = 15   # khoang cach gioi han den vat can

# define global variable
robot_controller = EnginesController()
us_sensor_controller = UltrasonicSensorsController()
gas_sensor_controller = GasSensorController()

network_util = NetworkUtils()
azure_hub_utils = AzureIoTHubUtils()
command_utils = CommandDirectUtils()


def main():
    print('Start robot ...')

    print('========================')
    print('Connect to azure iot hub ....')
    if azure_hub_utils.connectHub() == False:
        print('Cannot connect to azure hub!')
        quit()
    time.sleep(1)
    print('Connected\n')

    
    print('========================')
    print('Connect to server ...')
    if network_util.pingConnectToServer() == False:
        print('Cannot connect to server!')
        quit()
    time.sleep(1)
    print('Connected\n')

    
    # create thread to listen direct command
    print ("Ready for direct commands")
    command_utils.create_command_listener()


    # Connection Done
    print('========================')
    print('Let\'s start !')
    
    # gas_index = random.randint(50, 250)
    # asyncio.run(azure_hub_utils.sendMessage(gas_index))

    # main loop
    while True: 

        match command_utils.command:
            case Command.START:
                # run the algorithm and send status to server
                if gas_sensor_controller.isGasDetected() :
                    gas_index = random.randint(50, 250)
                    asyncio.run(azure_hub_utils.sendMessage(gas_index))
                asyncio.run(azure_hub_utils.sendMessage())

                
            case Command.PAUSE:
                # Robot tam dung
                pass
                
                
            case Command.FINISH:
                # Robot finish, draw image and send to server
                pass
                
                
            case Command.SPEED_UP:
                # speed up robot to 5
                # then continue running
                command_utils.command = Command.START
                pass

                
                
            case Command.SPEED_DOWN:
                # speed down robot to 5
                # then continue running
                command_utils.command = Command.START
                pass

            case _:
                pass
       


    # while True:
    #     if gas_sensor_controller.isGasDetected() :
    #         asyncio.run(azure_hub_utils.sendMessage(124))
    #     else :
    #         asyncio.run(azure_hub_utils.sendMessage())

    """
    try:
        distance_front = 0

        while True:
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

    """

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("Device stopped by user")
    finally:
        print("Shutting down robot. Dispose all resource.")
        # if azure_hub_utils.client is not None :
        #     azure_hub_utils.client.shutdown()
        
        # if command_listener is not None :
        #     command_listener.shutdown()

        if network_util.pingDisconnectToServer() == False:
            print('Cannot disconnect!')
            quit()
        print('Disconnected\n')