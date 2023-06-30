const invokeDeviceMethod = require('./common/invoke_direct_method');

let values = [0, 0, 0, 1, 0];
invokeDeviceMethod.startControlDevice("RB23GD1708", "raspberry-pi3", values, function (err, result){
    if (err) {
        console.error("Direct method error: "+err.message);
    } else {
        console.log("Successfully invoked the device.");
        console.log(result);
    }
});