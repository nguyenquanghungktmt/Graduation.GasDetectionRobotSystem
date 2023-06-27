import json
import uuid
import random
import asyncio
import time
from azure.iot.hub import IoTHubRegistryManager
from datetime import datetime


CONNECTION_STRING_SERVER = "HostName=gas-detekt-hub.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=9qwm+d1a2tA9z6NNniEiQv25EnCkQ5O/QBMPdDP1vJ4="
DEVICE_ID = "RB23GD1708"
FILE_PATH = "./config.json"
MESSAGE_TIMEOUT = 10000
INTERVAL = 5
NUM_RETRIES = 3

# Define the JSON message to send to IoT Hub.
TEMPERATURE = 20.0
HUMIDITY = 60
MSG_TXT = "{\"temperature\": %.2f,\"humidity\": %.2f}"

class AzureIoTHubUtils(object):
    def __init__(self):
        self.connectionServerString = CONNECTION_STRING_SERVER
        self.deviceId = DEVICE_ID

    def connectHub(self):
        for i in range(NUM_RETRIES):
            try:
                self.client = IoTHubRegistryManager(self.connectionServerString)
                return True
            except:
                # Clean up in the event of failure
                print('Try connect azure hub again ...')
                time.sleep(1)
                if i == (NUM_RETRIES - 1) :
                    return False
                pass

    async def sendMessage(self, gas_index=0,):
        # Build the message with simulated telemetry values.
        data = {
            "timestamp": datetime.now().strftime("%H:%M:%S"),
            "gas": gas_index,
            "device_id": DEVICE_ID,
        }

        # Add standard message properties
        message = json.dumps(data)

        # Send the message.
        print("Sending message: %s" % message)
        try:
            self.client.send_c2d_message(self.deviceId, message)
        except Exception as ex:
            print("Error sending message from device: {}".format(ex))
            
        await asyncio.sleep(INTERVAL)


if __name__ == '__main__':
    azure_hub_utils = AzureIoTHubUtils()
    azure_hub_utils.connectHub()
    asyncio.run(azure_hub_utils.sendMessage())