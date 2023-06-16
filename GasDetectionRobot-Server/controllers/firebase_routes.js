const { firebase_admin } = require('../common/firebase_admin');
const config = require('config');
const express = require("express");
const logger = require("../common/log.js");
const response = require("../common/response.js");

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
            id: "12321",
        },
        token: registrationToken,
    }
    
    firebase_admin.messaging().send(message).then(() => {
        return res.status(200).send(response.createResponse(1, 200, "Success"));
    })
    .catch( error => {
        return res.status(500).send(response.createResponse(0, 500, `Error ${error}`));
    });
})


router.get('/pingFirebase', (req, res)=>{
    logger.info(`Client request: ping_firebase - ${JSON.stringify(req.body)}`);

    let message = {
        notification: {
            title: "Test Firebase Notify",
            body: "Testttttttt."
        },
        token: config.get('firebase.token_default'),
    }
    
    firebase_admin.messaging().send(message).then(() => {
        return res.status(200).send(response.createResponse(1, 200, "Ping Success"));
    })
    .catch( error => {
        return res.status(500).send(response.createResponse(0, 500, `Ping Error ${error}`));
    });
})

module.exports = router;