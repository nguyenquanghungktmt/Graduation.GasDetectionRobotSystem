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

module.exports = router;
