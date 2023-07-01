'use strict';

const config = require('config');
const datetime = require('./datetime');
var Client = require('azure-iothub').Client;

// var connectionString = "HostName=gas-detekt-hub.azure-devices.net;SharedAccessKeyName=service;SharedAccessKey=Td965se6zlTDK+ERMqR+4LbDFjR5E9O5BTeqfhwQyDA=";

// var deviceId = "RB23GD1708";
// var moduleId = "raspberry-pi3";


module.exports = { 
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