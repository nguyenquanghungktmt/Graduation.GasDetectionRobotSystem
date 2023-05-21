const express = require("express");
const database = require("../common/connect.js");
const logger = require("../common/log.js");

// define a router
var router = express.Router();
router.use(express.json({ type: "*/*" }));

router.get("/", function (req, res) {
  res.json({ message: "Server alive" });
});

/**
 *
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

router.post("/register", function (req, res) {
  console.log("Client request: ", req.body)
  logger.info(`Client request - status= ${ req.body.status}`);

  res.json({ message: `register success - email = ${ req.body.email}` });
});

module.exports = router;
