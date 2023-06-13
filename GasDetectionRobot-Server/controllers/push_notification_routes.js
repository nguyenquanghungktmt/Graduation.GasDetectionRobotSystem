const { firebase_admin } = require('../common/firebase_admin');
const express = require("express");

// define a router
var router = express.Router();

router.post('/push_notification', (req, res)=>{
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
    
    firebase_admin.messaging().send(message).then(response => {
        return res.status(200).send({
            message: "Success"
        });
    })
    .catch( error => {
        return res.status(500).send({
            message: error
        });
    });
})

module.exports = router;