var config = require("config");
var mysql = require("mysql");
const fs = require('fs');
const datetime = require("./common/datetime")
const { query, data } = require("./common/log");
const database = require("./common/connect.js");

// test mysql connection
// var con = mysql.createConnection({
//     host: config.get("mysql.host"),
//     user: config.get("mysql.user"),
//     password: config.get("mysql.password"),
//     database: config.get("mysql.database"),
//     port: config.get("mysql.port"),
//     multipleStatements: true
//   });

// var conn = mysql.createConnection({
//     host: config.get("mysql.host"),
//     user: config.get("mysql.user"),
//     password: config.get("mysql.password"),
//     database: config.get("mysql.database"),
//     port: config.get("mysql.port"),
//     ssl: {
//         ca: fs.readFileSync(
//             config.get("mysql.path_ssl_cert")
//         )
//     },
//     multipleStatements: true
// });
  
// conn.connect(function(err) {
// if (err) throw err;
// console.log("Connected!");
// });

// querySql = `SELECT COUNT(*) as count FROM user WHERE device_serial_number = "RB23GT1708";`;
// con.connect(function(err) {
//     if (err) throw err;

//     console.log("Connected!");
//     console.log(querySql);

//     con.query(querySql, function(err, result){
//       if (err) throw err;

//       console.log(result[0].count);
//       con.end();
//     })
// });

// con.connect(function(err) {
//   if (err) throw err;
//   con.query("SELECT * FROM device", function (err, result, fields) {
//     if (err) throw err;
//     console.log(result);
//     console.log(result[0].model_name);
//   });
// });

console.log(datetime.getDatetimeNow())
let conn = database.createConnection();