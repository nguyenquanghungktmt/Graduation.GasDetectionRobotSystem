const express = require("express");
const uuid = require("uuid")
const database = require("../common/connect.js");
const logger = require("../common/log.js");
const datetime = require("../common/datetime.js");

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
      console.log(err);
      res.status(400).json({ 
        status: "Fail",
        message: "Error in database operation" 
      });
      
    } else {
      if (!result.length) {
        res.status(200).json({ 
          status: "Fail",
          message: "Username or Password wrong!" 
        });
      } 
      else res.status(200).json({
        status: "Success",
        message: "Login Success",
        data: result[0]
      });
    }
    conn.end();
  });

  console.log("===========");
});


// registration
router.post('/register', function(req, res){
  console.log("Client request: ", req.body)
  logger.info(`Client request: registration - ${JSON.stringify(req.body)}`);

  let first_name = req.body.first_name ?? '';
  let last_name = req.body.last_name ?? '';
  let username = req.body.user_name ?? '';
  let email = req.body.email ?? '';
  let password = req.body.password ?? '';
  let avatarUrl = req.body.avatar_url ?? '';
  let serialNumber = req.body.serial_number ?? '';
  

  var listQueryCheck = []
  listQueryCheck.push(`SELECT COUNT(*) as cnt FROM user WHERE username = "${username}"`);
  listQueryCheck.push(`SELECT COUNT(*) FROM user WHERE email = "${email}"`);
  listQueryCheck.push(`SELECT COUNT(*) FROM user JOIN device ON user.device_serial_number!="${serialNumber}" AND device.serial_number="${serialNumber}";`);

  console.log(listQueryCheck)

  
  // Kiểm tra xem tài khoản đã tồn tại hay chưa
  const conn = database.createConnection();
  conn.query(listQueryCheck.join('; '), function(err, results){
    
    console.log(results)
    console.log(results[0].cnt)
    // console.log(results[0].count);
    // console.log(typeof results[0]);
    if (err) {
      console.log("Query error first time");
      res.status(400).json({ 
        status: "Fail",
        message: "Server Error !" 
      });
      throw err
    }

    // Đã tồn tại tài khoản
    if(Number(results[0].count) > 0){
      res.send({
        status: 'Fail', 
        message: 'Username has existed. Please try another.'
      })
      conn.end()
    }
    else if(Number(results[1].count) > 0){
      res.send({
        status: 'Fail', 
        message: 'Email has existed. Please try again.'
      })
      conn.end()
    }
    else if(!Number(results[2].count)){
      res.send({
        status: 'Fail', 
        message: 'Serial Number of device is wrong or already used. Please check again.'
      })
      conn.end()
    }
    else{
      //Thêm tài khoản vào db
      let uuid_user = uuid.v4();
      let currentTime = datetime.getDatetimeNow();
      let querryInsertAcc = `INSERT INTO user (uuid, username, first_name, last_name, email, password, avatar_url, device_serial_number, created_time, modified_time) VALUES ('${uuid_user}', '${username}', '${first_name}', '${last_name}', '${email}', '${password}', '${avatarUrl}', '${serialNumber}', '${currentTime}', '${currentTime}')`;
      
      
      // console.log(querryInsertAcc);
      conn.query(querryInsertAcc, function(err, result){
        if(err) {
          console.log("Query error first time");
          res.status(400).json({ 
            status: "Fail",
            message: "Server Error !" 
          });
          throw err
        }

        res.send({
          status: 'Success',
          message: 'Registration Success',
          data: result[0]
        })
        conn.end()
      })
    }
  })
  
  console.log("===========");
})

module.exports = router;
