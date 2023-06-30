import requests
import json

DOMAIN = "https://gas-detekt-system.azurewebsites.net/"
FILE_PATH = "./config.json"
NUM_RETRIES = 3

class NetworkUtils(object):

    def __init__(self, domain=DOMAIN):
        self.domain = domain
        self.loadDeviceConfig()

    def loadDeviceConfig(self):
        f = open(FILE_PATH)
        data = json.load(f)
        self.deviceId = data['device_id']
        self.deviceName = data['device_name']

    def sendSeviceStatus(self):
        domain_tail = "sendRobotStatus"
        link_api = self.domain + domain_tail

        headers = {'content-type': 'application/json'}
        # fake data
        data = {"id": "9ebbd0b2576055739", 
                "name": "raspberry_pi_3",
                "model": "model b",
                "status": "no danger"}
        response = requests.post(link_api, data=json.dumps(data), headers=headers)

        print(response.text)

    def pingConnectToServer(self):
        domain_tail = "/device/pingConnectionDevice"
        link_api = self.domain + domain_tail

        headers = {'content-type': 'application/json'}
        data = {
            "device_serial_number": self.deviceId, 
            "connect_azure_hub": True,
        }
        for _ in range(NUM_RETRIES):
            try:
                response = requests.post(link_api, data=json.dumps(data), headers=headers)

                if response.status_code == 200:
                    body = json.loads(response.text)
                    print('Server response:', body['message'])
                    return (body['code'] == 200)
                else :
                    print('Server error with code', response.status_code)
                    return False
            except requests.exceptions.ConnectionError:
                print('Try connect server again ...')
                pass

        return False
    
    def pingDisconnectToServer(self):
        domain_tail = "/device/pingConnectionDevice"
        link_api = self.domain + domain_tail

        headers = {'content-type': 'application/json'}
        data = {
            "device_serial_number": self.deviceId
        }
        for _ in range(NUM_RETRIES):
            try:
                response = requests.post(link_api, data=json.dumps(data), headers=headers)

                if response.status_code == 200:
                    body = json.loads(response.text)
                    print('Server response:', body['message'])
                    return (body['code'] == 200)
                else :
                    print('Server error with code', response.status_code)
                    return False
            except requests.exceptions.ConnectionError:
                print('Try connect server again ...')
                pass

        return False

if __name__ == '__main__':
    network_utils = NetworkUtils()
    print(network_utils.pingDisconnectToServer())