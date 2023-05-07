import requests
import json

DOMAIN = "http://localhost:3000/"

class NetworkUtil(object):

    def __init__(self, domain=DOMAIN):
        self.domain = domain

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

if __name__ == '__main__':
    network_util = NetworkUtil()
    network_util.sendSeviceStatus()