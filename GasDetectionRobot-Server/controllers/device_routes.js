const express = require("express");
const uuid = require("uuid")
const database = require("../common/connect.js");
const logger = require("../common/log.js");
const datetime = require("../common/datetime.js");
const response = require("../common/response.js");

// define a router
let router = express.Router();

/**
 * API device
 */
router.get("/getStatusDevice", function (req, res) {
  logger.info(`Client request`);

  res.json({ message: "Server busy" });
});

router.post("/sendRobotStatus", function (req, res) {
  console.log("Client request: ", req.body)
  logger.info(`Client request - status= ${ req.body.status}`);

  res.json({ message: `Server busy - id = ${ req.body.id}` });
});

// get list room api //
router.post("/getDeviceInfo", function (req, res) {
    console.log("Client request: ", req.body)
    logger.info(`Client request: getDeviceInfo - ${JSON.stringify(req.body)}`);
  
    let serial_number = req.body.serial_number ?? '';
    var query = `SELECT * FROM device WHERE serial_number='${serial_number}';`;
  
  
    const conn = database.createConnection();
    conn.query(query, function (err, result) {
      if (err) {
        res.status(404).json(response.createResponse(0, 404, "Server Error !"));
      } else {
        if (!result.length) {
            res.status(200).json(response.createResponse(1, 400, "Cannot get device detail information."));
          } 
          else res.status(200).json(response.createResponse(1, 200, "Success", result[0]));
      }
      conn.end();
    });
  
    console.log("===========");
});


// api send device connection status to server //
router.post("/sendDeviceConnectStatus", function (req, res) {
  console.log("Client request - sendDeviceConnectStatus: ", req.body)
  logger.info(`Client request - sendDeviceConnectStatus= ${ req.body.status}`);

  res.json({ message: `Server busy` });
});


// api check device connection status //
router.post("/checkConnectDevice", function (req, res) {
  console.log("Client request - sendDeviceConnectStatus: ", req.body)
  logger.info(`Client request - sendDeviceConnectStatus= ${ req.body.status}`);

  res.json({ message: `Server busy` });
});

module.exports = router;