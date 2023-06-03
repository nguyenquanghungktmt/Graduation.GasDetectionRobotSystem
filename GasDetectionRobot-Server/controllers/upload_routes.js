const express = require('express');

const router = express.Router();
const upload = require('../common/upload');
const Resize = require('../common/resize');


router.post('/uploadAvatar', upload.single('image'), async function (req, res) {
    console.log("Client request: ", req.body)
    const imagePath = './public/images';
    const fileUpload = new Resize(imagePath);
    if (!req.file) {
        return res.status(401).json({error: 'Please provide an image'});
    }
    const filename = await fileUpload.saveAvatar(req.file.buffer);
    return res.status(200).json({ name: filename });
});

module.exports = router;
