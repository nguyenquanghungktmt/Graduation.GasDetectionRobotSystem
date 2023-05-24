var config = require("config");
var mysql = require("mysql");
const logger = require("../common/log.js");

// define mysql connection
module.exports = {
  createConnection: function (){
    const connection = mysql.createConnection({
      host: config.get("mysql.host"),
      user: config.get("mysql.user"),
      password: config.get("mysql.password"),
      database: config.get("mysql.database"),
      port: config.get("mysql.port"),
      multipleStatements: true
    })
    connection.connect(function (err, connection) {
      if (err) {
        console.log("Failed connection to mysql database.\n");
        logger.error(
          `Failed connection to mysql database. Error: ${err.message}`
        );
      }
    });

    return connection
  }
}