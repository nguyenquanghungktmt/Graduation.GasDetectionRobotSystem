import json
import uuid
import random
import asyncio
from azure.iot.device.aio import IoTHubDeviceClient
from azure.iot.device import Message


FILE_PATH = "./config.json"
MESSAGE_TIMEOUT = 10000
INTERVAL = 1
NUM_RETRIES = 3

# Define the JSON message to send to IoT Hub.
TEMPERATURE = 20.0
HUMIDITY = 60
MSG_TXT = "{\"temperature\": %.2f,\"humidity\": %.2f}"

class AzureIoTHubUtils(object):
    def __init__(self):
        f = open(FILE_PATH)
        data = json.load(f)
        self.connectionString = data['connection_string']
        self.deviceName = data['device_name']


    async def connectHub(self):
        for i in range(NUM_RETRIES):
            try:
                self.client = IoTHubDeviceClient.create_from_connection_string(self.connectionString)
                await self.client.connect()
                return True
            except:
                # Clean up in the event of failure
                await self.client.shutdown()
                print('Try connect azure hub again ...')
                await asyncio.sleep(1)
                if i == (NUM_RETRIES - 1) :
                    return False
                pass


    async def sendMessage(self, data=None):
        # Build the message with simulated telemetry values.
        temperature = TEMPERATURE + (random.random() * 15)
        humidity = HUMIDITY + (random.random() * 20)
        msg_txt_formatted = MSG_TXT % (temperature, humidity)
        message = Message(msg_txt_formatted)

        # Add standard message properties
        message.message_id = uuid.uuid4()
        message.content_encoding = "utf-8"
        message.content_type = "application/json"

        # Send the message.
        print("Sending message: %s" % message.data)
        try:
            await self.client.send_message(message)
        except Exception as ex:
            print("Error sending message from device: {}".format(ex))
            
        await asyncio.sleep(0.05)


if __name__ == '__main__':
    azure_hub_utils = AzureIoTHubUtils()
    asyncio.run(azure_hub_utils.connectHub())
    asyncio.run(azure_hub_utils.sendMessage())