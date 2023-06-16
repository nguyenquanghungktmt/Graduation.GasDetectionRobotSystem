const express = require("express");
const uuid = require("uuid");
const config = require('config');
const database = require("../common/connect.js");
const logger = require("../common/log.js");
const datetime = require("../common/datetime.js");
const response = require("../common/response.js");
const upload = require('../common/upload');
const Resize = require('../common/resize');
const device_status = require('../enum').DEVICE_STATUS;

// define a router
var router = express.Router();

router.get("/", function (req, res) {
  res.json({ message: "Server alive" });
});

// login api //
router.post("/login", function (req, res) {
  logger.info(`Client request: login - ${JSON.stringify(req.body)}`);

  let username = req.body.username ?? '';
  let password = req.body.password ?? '';
  let firebaseToken = req.body.firebase_token ?? '';
  // console.log("firebaseToken: ", firebaseToken);

  if (!firebaseToken) {
    res.status(200).json(response.createResponse(1, 400, "Firebase token is null or empty!"));
    return;
  }

  var query = `SELECT * FROM user WHERE username='${username}' and password='${password}';`;

  const conn = database.createConnection();
  conn.query(query, function (err, result) {
    if(err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"))
      throw err
    }
    
    if (!result.length) {
      res.status(200).json(response.createResponse(1, 400, "Username or Password wrong!"));
      conn.end();
    } 
    else {
      let updateQuery = `UPDATE user SET firebase_token=?, modified_time=? WHERE username=? and password=?;`;
      let values = [
        firebaseToken,
        datetime.getDatetimeNow(),
        username,
        password,
      ]

      conn.query(updateQuery, values, function(err){
        if(err) {
          res.status(404).json(response.createResponse(0, 404, "Server Error !"))
          throw err
        }
        res.status(200).json(response.createResponse(1, 200, "Login Success", result[0]));
        conn.end()
      })
    
    }
  });

  console.log("===========");
});


// registration
router.post('/register', upload.single('image'), async function (req, res){
  logger.info(`Client request: registration - ${JSON.stringify(req.body)}`);

  let first_name = req.body.first_name ?? '';
  let last_name = req.body.last_name ?? '';
  let username = req.body.username ?? '';
  let email = req.body.email ?? '';
  let password = req.body.password ?? '';
  // let avatarUrl = req.body.avatar_url ?? '';
  let serialNumber = req.body.serial_number ?? '';
  let firebaseToken = req.body.firebase_token ?? '';

  if (!firebaseToken) {
    res.status(200).json(response.createResponse(1, 400, "Firebase token is null or empty!"));
    return;
  }

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
      let querryInsertAcc = `INSERT INTO user (uuid, username, first_name, last_name, email, password, avatar_url, device_serial_number, created_time, modified_time, firebase_token) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
      
      
      // console.log(querryInsertAcc);
      conn.query(querryInsertAcc, values, function(err, result){
        if(err) {
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


// api check app-device connection status and set session  //
router.post("/pingConnectA2D", function (req, res) {
  logger.info(`Client request - pingConnectA2D= ${ JSON.stringify(req.body) }`);

  let userId = req.body.user_uuid ?? '';
  let roomId = req.body.room_id ?? '';
  let serial_number = req.body.device_serial_number ?? '';

  var query = `SELECT COUNT(*) as count FROM device WHERE serial_number=? AND device_status=?;`;
  let querryValues = [
      serial_number,
      device_status.ACTIVE
  ]

  const conn = database.createConnection();
  conn.query(query, querryValues, function (err, result) {
    if (err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
      conn.end()
    } else {
      if (result[0].count > 0) {

        let updateQuery = `UPDATE session SET user_uuid=?, room_id=?, serial_number=?, created_time=?, modified_time=? WHERE session_id=?;`;
        
        let time_now = datetime.getDatetimeNow();
        let values = [
          userId,
          roomId,
          serial_number,
          time_now,
          time_now,
          config.get("session_id_default")
        ]

        // update status of device to db
        conn.query(updateQuery, values, function(err){
          if(err) {
            res.status(404).json(response.createResponse(0, 404, "Server Error !"))
            throw err
          }
          res.status(200).json(response.createResponse(1, 200, "Connect success!"));
          conn.end()
        })
      } 
      else {
        res.status(200).json(response.createResponse(1, 200, "Your device is inactive. Try again."));
        conn.end();
      }
    }
  });
  console.log("===========");
});

module.exports = router;
