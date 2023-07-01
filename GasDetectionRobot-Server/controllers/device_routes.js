const express = require("express");
const database = require("../common/connect.js");
const logger = require("../common/log.js");
const datetime = require("../common/datetime.js");
const response = require("../common/response.js");
const invoke_control_device = require('../common/invoke_direct_method');
const device_status = require('../enum').DEVICE_STATUS

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
  logger.info(`Client request - status= ${ req.body.status}`);

  res.json({ message: `Server busy - id = ${ req.body.id}` });
});

// get list room api //
router.post("/getDeviceInfo", function (req, res) {
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
router.post("/pingConnectionDevice", function (req, res) {
  logger.info(`Client request - pingConnectionDevice= ${JSON.stringify(req.body)}`);

  let serial_number = req.body.device_serial_number ?? '';
  let connect_azure_hub = req.body.connect_azure_hub ?? false;
  var query = `SELECT * FROM device WHERE serial_number='${serial_number}';`;


  const conn = database.createConnection();
  conn.query(query, function (err, result) {
    if (err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
    } else {
      if (!result.length) {
        res.status(200).json(response.createResponse(1, 400, "Cannot recognize your device in system. Please try again."));
        conn.end();
      } 
      else {
        let updateQuery = `UPDATE device SET device_status=?, modified_time=? WHERE serial_number=?;`;

        let status = connect_azure_hub ? device_status.ACTIVE : device_status.INACTIVE;
        let values = [
          status,
          datetime.getDatetimeNow(),
          serial_number,
        ]

        // update status of device to db
        conn.query(updateQuery, values, function(err){
          if(err) {
            res.status(404).json(response.createResponse(0, 404, "Server Error !"))
            throw err
          }
          res.status(200).json(response.createResponse(1, 200, "Success"));
          conn.end()
        })

      }
    }
  });

  console.log("===========");
});


// api send device disconnection status to server //
router.post("/pingDisconnectionDevice", function (req, res) {
  logger.info(`Client request - pingDisconnectionDevice= ${JSON.stringify(req.body)}`);

  let serial_number = req.body.device_serial_number ?? '';
  var query = `SELECT * FROM device WHERE serial_number='${serial_number}';`;


  const conn = database.createConnection();
  conn.query(query, function (err, result) {
    if (err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
      conn.end()
    } else {
      if (!result.length) {
        res.status(200).json(response.createResponse(1, 400, "Cannot recognize your device in system. Please try again."));
        conn.end();
      } 
      else {
        let updateQuery = `UPDATE device SET device_status=?, modified_time=? WHERE serial_number=?;`;

        let values = [
          device_status.INACTIVE,
          datetime.getDatetimeNow(),
          serial_number,
        ]

        // update status of device to db
        conn.query(updateQuery, values, function(err){
          if(err) {
            res.status(404).json(response.createResponse(0, 404, "Server Error !"))
            throw err
          }
          res.status(200).json(response.createResponse(1, 200, "Success"));
          conn.end()
        })

      }
    }
  });

  console.log("===========");
});

// api invoke direct method to control device //
router.post("/controlDevice", function (req, res) {
  logger.info(`Client request - pingDisconnectionDevice= ${JSON.stringify(req.body)}`);

  let deviceId = req.body.device_serial_number ?? '';
  let moduleId = req.body.module_id ?? '';

  let command = req.body.command ?? '';

  invoke_control_device.startControlDevice(deviceId, moduleId, command, function (err, result){
    if (err) {
      console.error("Direct method error: " + err.message);
      console.log("===========");
      res.status(200).json(response.createResponse(0, 400, "Control device error"))
    } else {
      console.log(`Successfully invoked the device: ${JSON.stringify(result)}`);
      console.log("===========");
      res.status(200).json(response.createResponse(1, 200, "Successfully invoked."));
    }
  });

  console.log("===========");
});

module.exports = router;