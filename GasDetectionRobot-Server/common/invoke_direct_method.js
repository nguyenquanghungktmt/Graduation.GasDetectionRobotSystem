'use strict';

const config = require('config');
var Client = require('azure-iothub').Client;

// var connectionString = "HostName=gas-detekt-hub.azure-devices.net;SharedAccessKeyName=service;SharedAccessKey=Td965se6zlTDK+ERMqR+4LbDFjR5E9O5BTeqfhwQyDA=";

// var deviceId = "RB23GD1708";
// var moduleId = "raspberry-pi3";


module.exports = { 
    startControlDevice: function(deviceId, moduleId, values, callback) {
        const connectionString = config.get("azure.service_connection_string");
        const client = Client.fromConnectionString(connectionString);
        const methodParams = {
            methodName: "device_control",
            payload: {
                "start": values[0],
                "pause": values[1],
                "finish": values[2],
                "speed_up": values[3],
                "speed_down": values[4]
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