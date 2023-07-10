const Protocol = require('azure-iot-device-mqtt').Mqtt;
const Client = require('azure-iot-device').Client;

module.exports = {
  /**
   * function getMQTTClient get azure iot hub connection client
   * @param {Object} device device object
   * @returns azure iot hub connection client
   */
  getMQTTClient: function(device){
    const connectionString = `HostName=${device["host_name"]};DeviceId=${device["device_id"]};SharedAccessKey=${device["share_access_key"]}`;
    const client = Client.fromConnectionString(connectionString, Protocol);
    client.open(function (err) {
        if (err) {
          console.error(err.toString());
          process.exit(-1);
        } else {
          console.log('Azure Hub Client successfully connected');
        }
    })
    return client
  }
}