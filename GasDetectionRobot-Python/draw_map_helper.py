import numpy as np
import random
import matplotlib.pyplot as plt
import cv2
import json

FILE_PATH = "./config.json"
IMAGE_PATH = "map2d-{deviceId}.png"

class DrawMapHelper:
    def __init__(self) -> None:
        pass

    def __init__(self, listPoint=[]):
        self.listPoint = listPoint
        self.loadDeviceConfig()

    def loadDeviceConfig(self):
        f = open(FILE_PATH)
        data = json.load(f)
        self.deviceId = data['device_id']
        self.deviceName = data['device_name']

    def drawImg(self):
        points = self.listPoint
        plt.rc('figure', figsize=(8, 8))
        plt.axis('off')
        plt.tick_params(axis='both', labelsize=0, length = 0)
        plt.plot(points[:,0], points[:,1], '.',color='r', markersize=10)
        plt.savefig(IMAGE_PATH.format(deviceId=self.deviceId), bbox_inches="tight")
        # plt.show()

    def uploadImage(self):
        pass


if __name__ == "__main__":
    points = np.random.uniform(-100, 100, size=(200,2))
    drawer = DrawMapHelper(points)
    drawer.drawImg()
    # print(points)