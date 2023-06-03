const express = require("express");
const uuid = require("uuid")
const database = require("../common/connect.js");
const logger = require("../common/log.js");
const datetime = require("../common/datetime.js");
const response = require("../common/response.js");
const upload = require('../common/upload');
const Resize = require('../common/resize');

// define a router
var router = express.Router();

router.get("/", function (req, res) {
  res.json({ message: "Server alive" });
});

// login api //
router.post("/login", function (req, res) {
  console.log("Client request: ", req.body)
  logger.info(`Client request: login - ${JSON.stringify(req.body)}`);

  let username = req.body.username ?? '';
  let password = req.body.password ?? '';
  var query = `SELECT * FROM user WHERE username='${username}' and password='${password}';`;

  const conn = database.createConnection();
  conn.query(query, function (err, result) {
    if (err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
      
    } else {
      if (!result.length) {
        res.status(200).json(response.createResponse(1, 400, "Username or Password wrong!"));
      } 
      else res.status(200).json(response.createResponse(1, 200, "Login Success", result[0]));
    }
    conn.end();
  });

  console.log("===========");
});


// registration
router.post('/register', upload.single('image'), async function (req, res){
  console.log("Client request: ", req.body)
  // logger.info(`Client request: registration - ${JSON.stringify(req.body)}`);

  let first_name = req.body.first_name ?? '';
  let last_name = req.body.last_name ?? '';
  let username = req.body.username ?? '';
  let email = req.body.email ?? '';
  let password = req.body.password ?? '';
  // let avatarUrl = req.body.avatar_url ?? '';
  let serialNumber = req.body.serial_number ?? '';
  

  var listQueryCheck = []
  listQueryCheck.push(`SELECT COUNT(*) as count FROM user WHERE username = "${username}"`);
  listQueryCheck.push(`SELECT COUNT(*) as count FROM user WHERE email = "${email}"`);
  listQueryCheck.push(`SELECT COUNT(*) as count FROM device WHERE serial_number = "${serialNumber}"`);
  listQueryCheck.push(`SELECT COUNT(*) as count FROM user WHERE device_serial_number = "${serialNumber}"`);

  
  // check if username, email, serial_number is exist ?
  const conn = database.createConnection();
  conn.query(listQueryCheck.join('; '), async function(err, results){
    if (err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
      throw err
    }

    if(results[0][0].count){
      // Username already exist
      res.send(response.createResponse(1, 400, 'Username has existed. Please try another.'))
      conn.end()
    }
    else if(results[1][0].count){
      // Email already exist
      res.send(response.createResponse(1, 400, 'Email has existed. Please try again.'))
      conn.end()
    }
    else if(!results[2][0].count){
      // Serial number is wrong
      res.send(response.createResponse(1, 400, 'Serial Number of device is wrong. Please check again.'))
      conn.end()
    }
    else if(results[3][0].count){
      // Serial number already used
      res.send(response.createResponse(1, 400, 'Serial Number of device already used. Please try another.'))
      conn.end()
    }
    else{
      // Add new user account to DB
      let uuid_user = uuid.v4();
      let currentTime = datetime.getDatetimeNow();
      
      const imagePath = './public/images';
      const fileUpload = new Resize(imagePath);
      var avatarUrl = null;
      if (req.file) avatarUrl = await fileUpload.saveAvatar(req.file.buffer);


      let values = [
        uuid_user,
        username,
        first_name,
        last_name,
        email,
        password,
        avatarUrl,
        serialNumber,
        currentTime,
        currentTime
      ]
      let querryInsertAcc = `INSERT INTO user (uuid, username, first_name, last_name, email, password, avatar_url, device_serial_number, created_time, modified_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
      
      
      // console.log(querryInsertAcc);
      conn.query(querryInsertAcc, values, function(err, result){
        if(err) {
          console.log("Query error first time");
          res.status(404).json(response.createResponse(0, 404, "Server Error !"))
          throw err
        }
        
        let data = {
          "uuid": uuid_user,
          "first_name": first_name,
          "last_name": last_name,
          "username": username,
          "email": email,
          "avatar_url": avatarUrl,
          "device_serial_number": serialNumber
        }
        res.status(201).json(response.createResponse(1, 201, 'Registration Success', data))
        conn.end()
      })
    }
  })
  
  console.log("===========");
})


// logout //
router.post("/logout", function (req, res) {
  console.log("Client request: ", req.body)
  logger.info(`Client request: logout - ${JSON.stringify(req.body)}`);

  let uuid = req.body.uuid ?? '';
  var query = `SELECT * FROM user WHERE uuid='${uuid}';`;

  const conn = database.createConnection();
  conn.query(query, function (err, result) {
    if (err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
      
    } else {
      if (!result.length) {
        res.status(200).json(response.createResponse(1, 400, "Logout wrong! Please check your internet."));
      } 
      else res.status(200).json(response.createResponse(1, 200, "Logout Success"));
    }
    conn.end();
  });

  console.log("===========");
});

module.exports = router;
