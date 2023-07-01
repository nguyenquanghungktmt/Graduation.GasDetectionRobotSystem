const invokeDeviceMethod = require('./common/invoke_direct_method');

let command = "finish";
invokeDeviceMethod.startControlDevice("RB23GD1708", "raspberry-pi3", command, function (err, result){
    if (err) {
        console.error("Direct method error: "+err.message);
    } else {
        console.log("Successfully invoked the device.");
        console.log(result);
    }
});