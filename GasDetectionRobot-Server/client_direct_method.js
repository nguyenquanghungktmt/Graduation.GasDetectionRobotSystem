'use strict';

var Client = require('azure-iot-device').Client;
var Protocol = require('azure-iot-device-mqtt').Mqtt;

var connectionString = 'HostName=gas-detekt-hub.azure-devices.net;DeviceId=RB23GD1708;ModuleId=raspberry-pi3;SharedAccessKey=mXyfwmNJaVkjhbGg3LZ7y+syYb5oEiEn53WeoNIF2mk=';
var client = Client.fromConnectionString(connectionString, Protocol);

var onDeviceControl = function(request, response) {

    // Respond the cloud app for the direct method
    response.send(200, 'Device Control started', function(err) {
        if (err) {
            console.error('An error occurred when sending a method response:\n' + err.toString());
        } else {
            console.log('Response to method \'' + request.methodName + '\' sent successfully.');
            console.log(request.payload)
        }
    });

    // Add your device's reboot API for physical restart.
    console.log('Controling!');
};


client.open(function(err) {
    if (err) {
        console.error('Could not open IotHub client');
    }  else {
        console.log('Client opened.  Waiting for reboot method.');
        client.onDeviceMethod('device_control', onDeviceControl);
    }
});