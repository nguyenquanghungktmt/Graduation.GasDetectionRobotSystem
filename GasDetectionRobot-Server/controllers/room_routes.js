const express = require("express");
const database = require("../common/connect.js");
const logger = require("../common/log.js");
const response = require("../common/response.js");

// define a router
var router = express.Router();

/**
 * API Room
 */

// get list room api //
router.post("/getListRoom", function (req, res) {
  console.log("Client request: ", req.body)
  logger.info(`Client request: getListRoom - ${JSON.stringify(req.body)}`);

  let owner_uuid = req.body.owner_uuid ?? '';
  var query = `SELECT * FROM room WHERE owner_uuid='${owner_uuid}';`;


  const conn = database.createConnection();
  conn.query(query, function (err, result) {
    if (err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
    } else {
      let data = {
        "total_record": result.length,
        "items": result
      }
      res.status(200).json(response.createResponse(1, 200, "Success", data));
    }
    conn.end();
  });

  console.log("===========");
});

// API delete room //
router.post("/deleteRoom", function (req, res) {
  console.log("Client request: ", req.body)
  logger.info(`Client request: deleteRoom - ${JSON.stringify(req.body)}`);

  let room_id = req.body.room_id ?? '';
  let owner_uuid = req.body.owner_uuid ?? '';
  var searchQuery = `DELETE FROM room WHERE room_id='${room_id}' AND owner_uuid='${owner_uuid}';`;


  const conn = database.createConnection();
  conn.query(searchQuery, function (err, result) {
    if (err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
    } else {
      if(result.affectedRows){
        res.status(200).json(response.createResponse(1, 200, "Delete Success"));
      } else {
        res.status(200).json(response.createResponse(1, 400, "Delete Failed"));
      }
    }
    conn.end();
  });

  console.log("===========");
});

module.exports = router;
