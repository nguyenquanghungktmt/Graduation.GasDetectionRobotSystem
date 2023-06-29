// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

'use strict';

var Client = require('azure-iothub').Client;
var Registry = require('azure-iothub').Registry;

var connectionString = "HostName=gas-detekt-hub.azure-devices.net;SharedAccessKeyName=service;SharedAccessKey=Td965se6zlTDK+ERMqR+4LbDFjR5E9O5BTeqfhwQyDA=";

var targetDevice = "RB23GD1708/raspberry-pi3";

var methodParams = {
    methodName: "reboot",
    payload: null,
    responseTimeoutInSeconds: 30,
    connectTimeoutInSeconds: 10
};


var registry = Registry.fromConnectionString(connectionString);
var client = Client.fromConnectionString(connectionString);

var startRebootDevice = function(twin) {

    var methodName = "reboot";

    var methodParams = {
        methodName: "reboot",
        payload: null,
        responseTimeoutInSeconds: 30,
        connectTimeoutInSeconds: 10
    };

    client.invokeDeviceMethod(targetDevice, methodParams, function(err, result) {
        if (err) {
            console.error("Direct method error: "+err.message);
        } else {
            console.log("Successfully invoked the device to reboot.");  
        }
    });
};

startRebootDevice();