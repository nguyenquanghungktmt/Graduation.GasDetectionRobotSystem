// importl modules
const http = require("http");
const express = require("express");
const bodyParser = require("body-parser");

// setup express
const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// import routers
let routes = require("./controllers/routes.js");
let room_routes = require("./controllers/room_routes.js");
let device_routes = require("./controllers/device_routes.js");
app.use("/", routes);
app.use("/room", room_routes);
app.use("/device", device_routes);

// public folder public to access
app.use('/images', express.static('./public/images'));

// start server
const server = http.createServer(app);
var port = process.env.PORT || 3000;
server.listen(port, function () {
  // body...
  console.log("Server is running on port", port);
});
