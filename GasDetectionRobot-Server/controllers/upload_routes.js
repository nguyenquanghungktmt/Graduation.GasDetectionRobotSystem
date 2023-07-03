const express = require("express");
const uuid = require("uuid");
const config = require('config');
const database = require("../common/connect.js");
const logger = require("../common/log.js");
const datetime = require("../common/datetime.js");
const response = require("../common/response.js");
const upload = require('../common/upload');
const Resize = require('../common/resize');

// define a router
var router = express.Router();


router.post('/uploadMapImage', async function (req, res) {
    logger.info(`Client request: uploadImage - ${JSON.stringify(req.body)}`)

    const imagePath = './public/images';
    const fileUpload = new Resize(imagePath);
    if (!req.files.image) {
        return res.status(401).json({error: 'Please provide an image'});
    }
    const filename = await fileUpload.saveMapImage(req.files.image.data);
    return res.status(200).json({ name: filename });
});

module.exports = router;
