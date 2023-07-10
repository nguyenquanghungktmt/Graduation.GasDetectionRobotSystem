'use strict';

const config = require('config');
const datetime = require('./datetime');
var Client = require('azure-iothub').Client;

module.exports = { 
    /**
     * function startControlDevice invoke a direct method to azire iot hub, aim to control the device
     * @param {string} deviceId The string of device serial number
     * @param {string} moduleId module id registered in azure iot hub for direct method protocol
     * @param {string} command the command mobile app using to control the device
     * @param {callback} callback callback of func invokeDeviceMethod of auzure-iothub module
     * @returns {callback} callback handle success invoke or fail
     */
    startControlDevice: function(deviceId, moduleId, command, callback) {
        const connectionString = config.get("azure.service_connection_string");
        const client = Client.fromConnectionString(connectionString);
        const methodParams = {
            methodName: "device_control",
            payload: {
                "timestamp": datetime.getDatetimeNow(),
                "command": command
            },
            responseTimeoutInSeconds: 5,
            connectTimeoutInSeconds: 5
        };

        return client.invokeDeviceMethod(deviceId, moduleId, methodParams, function(err, result) {
            client.close()
            return callback(err, result)
        });
    }
}