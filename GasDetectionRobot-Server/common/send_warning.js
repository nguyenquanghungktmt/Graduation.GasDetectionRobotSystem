const config = require('config');
const { firebase_admin } = require('./firebase_admin');
const database = require("./connect.js");
const datetime = require("./datetime.js");
const logger = require("./log.js");

module.exports = {
    send: function (){
        logger.info(`Server detects gas leak. Send notify.`);

        // Get session
        const session_id = config.get("session_id_default");
        const query = `SELECT * FROM session WHERE session_id='${session_id}';`;

        const conn = database.createConnection();
        conn.query(query, function (err, result) {
            let user_uuid = result[0].user_uuid;
            let firebaseToken = result[0].firebase_token;
            let room_id = result[0].room_id;
            let serial_number = result[0].serial_number;
            let is_gas_detect = '1';
            let room_status = "Gas Leak. Very Danger.";


            // Push notification throw firebase
            let message = {
                notification: {
                    title: "Gas Detekt Warning",
                    body: room_status
                },
                data: {
                    room_id: room_id,
                    user_uuid: user_uuid,
                    serial_number: serial_number,
                    is_gas_detect: is_gas_detect,
                    room_status: room_status
                },
                token: firebaseToken,
            }
            firebase_admin.messaging().send(message);

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

        });
    }
}