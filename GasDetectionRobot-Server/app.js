// importl modules
// const http = require("http");
const express = require("express");
const bodyParser = require("body-parser");
const fileUpload = require('express-fileupload');
const config = require("config");
const mqttUtils = require('./mqtt_utils');
const send_warning = require('./common/send_warning');

// setup express
const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(fileUpload());

// import routers
let routes = require("./controllers/routes.js");
let room_routes = require("./controllers/room_routes.js");
let device_routes = require("./controllers/device_routes.js");
let firebase_routes = require("./controllers/firebase_routes.js");
// let upload_routes = require("./controllers/upload_routes.js");
app.use("/", routes);
app.use("/room", room_routes);
app.use("/device", device_routes);
app.use("/firebase", firebase_routes);
// app.use("/upload", upload_routes);

// public folder public to access
app.use('/images', express.static('./public/images'));

// create connect client to azure iot hub
const listDevices = config.get("devices_info");
const device = listDevices["RB23GD1708"];
const client = mqttUtils.getMQTTClient(device);

client.on('message', function (msg) {
  // Receive data from Azure Hub
  const message = msg.data.toString()

  console.log('----');
  console.log(message);
  console.log('----');

  let jsonParse = JSON.parse(message);
  let gas = jsonParse.gas ?? 0;
  let device_id = jsonParse.device_id ?? '';


  if (gas > 0) {
    send_warning.send(gas);
  }
});

// start server
// const server = http.createServer(app);
var port = process.env.PORT || 3000;
app.listen(port, function () {
  // body...
  console.log("Server is running on port", port);
});
