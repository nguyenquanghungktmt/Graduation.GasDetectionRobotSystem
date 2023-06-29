'use strict';

var Client = require('azure-iot-device').Client;
var Protocol = require('azure-iot-device-mqtt').Mqtt;

var connectionString = 'HostName=gas-detekt-hub.azure-devices.net;DeviceId=RB23GD1708;ModuleId=raspberry-pi3;SharedAccessKey=mXyfwmNJaVkjhbGg3LZ7y+syYb5oEiEn53WeoNIF2mk=';
var client = Client.fromConnectionString(connectionString, Protocol);

var onReboot = function(request, response) {

    // Respond the cloud app for the direct method
    response.send(200, 'Reboot started', function(err) {
        if (err) {
            console.error('An error occurred when sending a method response:\n' + err.toString());
        } else {
            console.log('Response to method \'' + request.methodName + '\' sent successfully.');
        }
    });

    // Report the reboot before the physical restart
    var date = new Date();
    var patch = {
        iothubDM : {
            reboot : {
                lastReboot : date.toISOString(),
            }
        }
    };

    // Get device Twin
    client.getTwin(function(err, twin) {
        if (err) {
            console.error('could not get twin');
        } else {
            console.log('twin acquired');
            twin.properties.reported.update(patch, function(err) {
                if (err) throw err;
                console.log('Device reboot twin state reported')
            });  
        }
    });

    // Add your device's reboot API for physical restart.
    console.log('Rebooting!');
};


client.open(function(err) {
    if (err) {
        console.error('Could not open IotHub client');
    }  else {
        console.log('Client opened.  Waiting for reboot method.');
        client.onDeviceMethod('reboot', onReboot);
    }
});