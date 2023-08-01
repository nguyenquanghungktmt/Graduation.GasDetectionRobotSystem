from azure.iot.device import IoTHubDeviceClient, MethodResponse
from helper.command_enum import Command
import json


# CONNECTION_STRING = "HostName=gas-detekt-hub.azure-devices.net;DeviceId=RB23GD1708;ModuleId=direct-command;SharedAccessKey=0y4ho/I/6jFX9L0bROZ5mdFojE29OprvxAdRZc2x8yQ="
# METHOD_NAME = "device_control"

FILE_PATH = "./config.json"

class CommandDirectUtils:
    def __init__(self):
        f = open(FILE_PATH)
        data = json.load(f)

        self.moduleConnectionString = data['module_connection_string']
        self.methodName = data['direct_method_name']
        self.command = Command.PAUSE
        self.client = IoTHubDeviceClient.create_from_connection_string(self.moduleConnectionString)

    def create_command_listener(self):
        # Define the handler for method requests
        def method_request_handler(method_request):
            if method_request.name == self.methodName:
                # Act on the method by rebooting the device
                print("- Incomming direct command:", self.methodName)
                payload = method_request.payload
                timestamp = payload["timestamp"]
                cmd = Command.parse(payload["command"])
                print("- {0} : {1}".format(timestamp, cmd))

                self.command = cmd


                # Create a method response indicating the method request was resolved
                resp_status = 200
                resp_payload = {"Response": "This is the response from the device"}
                method_response = MethodResponse(method_request.request_id, resp_status, resp_payload)

            else:
                # Create a method response indicating the method request was for an unknown method
                resp_status = 404
                resp_payload = {"Response": "Unknown method"}
                method_response = MethodResponse(method_request.request_id, resp_status, resp_payload)

            # Send the method response
            self.client.send_method_response(method_response)

        try:
            # Attach the handler to the client
            self.client.on_method_request_received = method_request_handler
        except:
            # In the event of failure, clean up
            self.client.shutdown()