const express = require("express");
const uuid = require("uuid");
const database = require("../common/connect.js");
const logger = require("../common/log.js");
const response = require("../common/response.js");
const datetime = require("../common/datetime.js");

// define a router
var router = express.Router();

/**
 * API Room
 */

// api get list room //
router.post("/getListRoom", function (req, res) {
  logger.info(`Client request: getListRoom - ${JSON.stringify(req.body)}`);

  let owner_uuid = req.body.owner_uuid ?? '';
  const query = `SELECT * FROM room WHERE owner_uuid='${owner_uuid}' ORDER BY created_time ASC;`;


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
  logger.info(`Client request: deleteRoom - ${JSON.stringify(req.body)}`);

  let room_id = req.body.room_id ?? '';
  let owner_uuid = req.body.owner_uuid ?? '';
  const deleteQuery = `DELETE FROM room WHERE room_id='${room_id}' AND owner_uuid='${owner_uuid}';`;


  const conn = database.createConnection();
  conn.query(deleteQuery, function (err, result) {
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

// API create room //
router.post("/createRoom", function (req, res) {
  logger.info(`Client request: createRoom - ${JSON.stringify(req.body)}`);

  let owner_uuid = req.body.owner_uuid ?? '';
  if (!owner_uuid) {
    res.status(200).json(response.createResponse(1, 400, "User is null or empty! Cannot create room"));
    return;
  }

  let room_id = uuid.v1();
  let room_name = "New Room";
  let is_gas_detect = 0;
  let room_status = "Normal";
  let map2d_url = null;
  let created_time = datetime.getDatetimeNow();
  let modified_time = datetime.getDatetimeNow();
  
  let roomValues = [
    room_id,
    room_name,
    owner_uuid,
    is_gas_detect,
    room_status,
    map2d_url,
    created_time,
    modified_time
  ]

  const createQuery = `INSERT INTO room (room_id, room_name, owner_uuid, is_gas_detect, room_status, map2d_url, created_time, modified_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?);`;


  const conn = database.createConnection();
  conn.query(createQuery, roomValues, function (err, result) {
    if (err) {
      console.log(err);
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
    } else {
      if(result.affectedRows){
        // create room success
        let newRoom = {
          "room_id": room_id,
          "room_name": room_name,
          "owner_uuid": owner_uuid,
          "is_gas_detect": is_gas_detect,
          "room_status": room_status,
          "map2d_url": map2d_url,
          "created_time": created_time,
          "modified_time": modified_time
        }
        res.status(200).json(response.createResponse(1, 201, "Create room success", newRoom));
      } else {
        res.status(200).json(response.createResponse(1, 400, "Create room failed"));
      }
    }
    conn.end();
  });

  console.log("===========");
});

// API update room: update room_name, is_gas_detect, room_status, modified_time//
router.post("/updateRoom", function (req, res) {
  logger.info(`Client request: updateRoom - ${JSON.stringify(req.body)}`);

  let room_id = req.body.room_id ?? '';
  let room_name = req.body.room_name ?? '';
  let is_gas_detect = req.body.is_gas_detect ?? 0;
  let room_status = req.body.room_status ?? '';
  let modified_time = datetime.getDatetimeNow();

  let updateQuery = `UPDATE room SET room_name=?, is_gas_detect=?, room_status=?, modified_time=? WHERE room_id=?;`;
  let values = [
    room_name,
    is_gas_detect,
    room_status,
    modified_time,
    room_id
  ]


  const conn = database.createConnection();
  conn.query(updateQuery, values, function (err, result) {
    if (err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
    } else {
      if(result.affectedRows){
        res.status(200).json(response.createResponse(1, 200, "Update Success"));
      } else {
        res.status(200).json(response.createResponse(1, 400, "Update Failed"));
      }
    }
    conn.end();
  });

  console.log("===========");
});

// api get list room connection session//
router.post("/getListSession", function (req, res) {
  logger.info(`Client request: getListSession - ${JSON.stringify(req.body)}`);

  let room_id = req.body.room_id ?? '';
  const query = `SELECT * FROM session WHERE room_id='${room_id}' ORDER BY created_time ASC;`;


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

module.exports = router;
