const { firebase_admin } = require('../common/firebase_admin');
const config = require('config');
const express = require("express");
const logger = require("../common/log.js");
const response = require("../common/response.js");
const target_enum = require('../enum').TARGET;

// define a router
var router = express.Router();

router.post('/pushNotification', (req, res)=>{
    logger.info(`Client request: push_notification - ${JSON.stringify(req.body)}`);

    const  registrationToken = req.body.registrationToken

    let message = {
        notification: {
            title: "Gas Detekt Notify",
            body: "Room Scanned. No gas leak detect."
        },
        data: {
            target: target_enum.ROOM,
            room_id: "d4c386d0-0d2c-11ee-9b29-65bc2cd4889c",
            is_gas_detect: `${Math.floor(Math.random() * 200) + 50}`,
            room_status: "Very Danger"
        },
        token: registrationToken,
    }
    
    firebase_admin.messaging().send(message).then(() => {
        return res.status(200).send(response.createResponse(1, 200, "Success"));
    })
    .catch( error => {
        return res.status(500).send(response.createResponse(0, 500, `Error ${error}`));
    });

    console.log("===========");
})


router.get('/pingFirebase', (req, res)=>{
    logger.info(`Client request: ping_firebase - ${JSON.stringify(req.body)}`);

    let message = {
        notification: {
            title: "Test Firebase Notify",
            body: "Testttttttt."
        },
        data: {
            target: target_enum.GENERAL,
        },
        token: config.get('firebase.token_default'),
    }
    
    firebase_admin.messaging().send(message).then(() => {
        return res.status(200).send(response.createResponse(1, 200, "Ping Success"));
    })
    .catch( error => {
        return res.status(500).send(response.createResponse(0, 500, `Ping Error ${error}`));
    });

    console.log("===========");
})

module.exports = router;