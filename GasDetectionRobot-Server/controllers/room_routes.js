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

module.exports = router;
