const { firebase_admin } = require('./firebase_admin');
const database = require("./connect.js");
const datetime = require("./datetime.js");
const logger = require("./log.js");
const target_enum = require('../enum').TARGET;

module.exports = {
    /**
     * func send: save gas value, status to database, push firebase notification
     * @param {Number} gas_index gas index that gas sensor collect
     */
    send: function (gas_index){
        logger.info(`Server detects gas leak. Send notify.`);

        // TODO: fix session here
        // Get the newest session connect to robot
        const query = 'SELECT * FROM session ORDER BY created_time DESC LIMIT 1;';

        const conn = database.createConnection();
        conn.query(query, function (err, result) {
            if (err) {
              throw err
            }
        
            if (!result.length) {
              console.log("No device app connect to robot");
              conn.end();
              return;
            } 

            let user_uuid = result[0].user_uuid;
            let firebaseToken = result[0].firebase_token;
            let room_id = result[0].room_id;
            let serial_number = result[0].serial_number;

            let is_gas_detect = `${gas_index}`;
            let room_status = gas_index < 150 ? "Gas Leak. Careful." : "Gas Leak. Very Danger.";

            // Save to DB
            let updateQuery = `UPDATE room SET is_gas_detect=?, room_status=?, modified_time=? WHERE room_id=?;`;
            let values = [
                is_gas_detect,
                room_status,
                datetime.getDatetimeNow(),
                room_id
            ]
            conn.query(updateQuery, values, function (err, res) {
                if (err) {
                    console.log("Update Warning Failed. Server error!");
                } else {
                    if (res.affectedRows){
                        console.log("Update Warning Success");
                    } else {
                        console.log("Update Warning Failed");
                    }
                    conn.end();
                }
            });

            // Push notification throw firebase
            let message = {
                notification: {
                    title: "Gas Detekt Warning",
                    body: room_status
                },
                data: {
                    target: target_enum.ROOM,
                    room_id: room_id,
                    user_uuid: user_uuid,
                    serial_number: serial_number,
                    is_gas_detect: is_gas_detect,
                    room_status: room_status
                },
                token: firebaseToken,
            }
            firebase_admin.messaging().send(message)
            .then(function (response) {
                console.log('Success firebase sent message:', response);
            })
            .catch(function (error) {
                console.log(`Error firebase push notification ${error}`);
            });

        });
    }
}