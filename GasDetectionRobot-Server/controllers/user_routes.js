const express = require("express");
const uuid = require("uuid");
const database = require("../common/connect.js");
const { firebase_admin } = require('../common/firebase_admin.js');
const logger = require("../common/log.js");
const datetime = require("../common/datetime.js");
const response = require("../common/response.js");
const upload = require('../common/upload.js');
const Resize = require('../common/resize.js');
const enums = require('../enum/index.js');
// const target_enum = require('../enum').TARGET;

// define a router
var router = express.Router();

/**
 * @api {get} / : system dashboard
 */
router.get("/", function (req, res) {
  res.json({ message: "Server alive" });
});


/**
 * @api {post} /login : login to system
 * @apiGroup /
 */
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


/**
 * @api {post} /register : registration new user to system
 * @apiGroup /
 */
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


/**
 * @api {post} /register : logout
 * @apiGroup /
 */
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


/**
 * @api {post} /pingConnectA2D : check app-device connection status and set new session
 * @apiGroup /
 */
router.post("/pingConnectA2D", function (req, res) {
  logger.info(`Client request - pingConnectA2D= ${ JSON.stringify(req.body) }`);

  let userId = req.body.user_uuid ?? '';
  let roomId = req.body.room_id ?? '';
  let firebaseToken = req.body.firebase_token ?? '';
  let serial_number = req.body.device_serial_number ?? '';

  var query = `SELECT COUNT(*) as count FROM device WHERE serial_number=? AND device_status=?;`;
  let querryValues = [
      serial_number,
      enums.DEVICE_STATUS.ACTIVE
  ]

  const conn = database.createConnection();
  conn.query(query, querryValues, function (err, result) {
    if (err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
      conn.end()
    } else {
      if (result[0].count > 0) {
        let insertQuery = 'INSERT INTO session (session_id, user_uuid, room_id, firebase_token, serial_number, created_time) VALUES (?, ?, ?, ?, ?, ?)';
      
        let values = [
          uuid.v1(),
          userId,
          roomId,
          firebaseToken,
          serial_number,
          datetime.getDatetimeNow(),
        ]

        // insert session of device to db
        conn.query(insertQuery, values, function(err){
          if(err) {
            res.status(404).json(response.createResponse(0, 404, "Server Error !"))
            throw err
          }
          res.status(200).json(response.createResponse(1, 200, "Connect success!"));
          conn.end()
        })
      } 
      else {
        res.status(200).json(response.createResponse(1, 400, "Your device is inactive. Try again."));
        conn.end();
      }
    }
  });
  console.log("===========");
});


/**
 * @api {post} /pingConnectA2D : upload map 2d image and save link to room in current session
 * @apiGroup /
 */
router.post('/uploadMapImage', async function (req, res) {
  logger.info(`Client request: uploadImage - ${JSON.stringify(req.body)}`)

  let serialNumber = req.body.device_serial_number ?? '';

  // Get newest session connect to device
  const query = 'SELECT * FROM session ORDER BY created_time DESC LIMIT 1;';

  const conn = database.createConnection();
  conn.query(query, async function (err, result) {
    if (err) {
      res.status(404).json(response.createResponse(0, 404, "Server Error !"));
      throw err
    }

    if (!result.length) {
      res.status(200).json(response.createResponse(1, 400, "No device app connect to robot"));
      conn.end();
    }

    let user_uuid = result[0].user_uuid ?? '';
    let firebaseToken = result[0].firebase_token ?? '';
    let room_id = result[0].room_id ?? '';
    let session_serial_number = result[0].serial_number ?? '';


    if (serialNumber != session_serial_number) {
      // Neu khong khop serial number
      res.status(200).json(response.createResponse(1, 400, "Upload image error"));
      conn.end();
      return;
    }

    // Save image    
    const imagePath = './public/images';
    const fileUpload = new Resize(imagePath);

    if (!req.files.image) {
      conn.end();
      res.status(200).json(response.createResponse(1, 400, "No image attach"));
    }
    const mapFilename = await fileUpload.saveMapImage(room_id, req.files.image.data);


    // Search room
    let searchQuery = `SELECT * FROM room WHERE room_id='${room_id}';`;


    conn.query(searchQuery, function (err, result) {
      if(err) {
        res.status(404).json(response.createResponse(0, 404, "Server Error !"))
        throw err
      }
      
      if (!result.length) {
        res.status(200).json(response.createResponse(1, 400, "Username or Password wrong!"));
        conn.end();
      }
      else {
        let room_name = result[0].room_name
        console.log(room_name);
        
        // Save to DB
        let updateQuery = `UPDATE room SET map2d_url=?, modified_time=? WHERE room_id=?;`;
        let values = [
          mapFilename,
          datetime.getDatetimeNow(),
          room_id
        ]
        
        conn.query(updateQuery, values, function(err, result){
          if(err) {
            res.status(404).json(response.createResponse(0, 404, "Server Error !"))
            throw err
          }

          if (result.affectedRows){
            console.log("Update image success");
            res.status(200).json(response.createResponse(1, 201, 'Update image success'))
          } else {
            console.log("Update image failed");
            res.status(200).json(response.createResponse(1, 201, 'Update image success'))
          }
          conn.end();
        })

        // Push notification throw firebase
        let message = {
          notification: {
            title: `${room_name} scan finished"`,
            body: "Here is map image"
          },
          data: {
            target: enums.TARGET.MAP,
            room_id: room_id,
            user_uuid: user_uuid,
            serial_number: session_serial_number,
            map2dUrl: mapFilename
          },
          token: firebaseToken,
        }
        firebase_admin.messaging().send(message)
        .then(function (response) {
            console.log('Success firebase sent message:', response);
            console.log("===========");
        })
        .catch(function (error) {
            console.log(`Error firebase push notification\n${error}`);
            console.log("===========");
        });        
      }
    });
  });


  console.log("===========");
});

module.exports = router;
