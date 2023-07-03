const uuid = require("uuid")
const path = require('path');
const jimp = require('jimp');

class Resize {

    constructor(folder) {
        this.folder = folder;
    }

    // func save avtar to folder /public/images
    async saveAvatar(buffer) {
        const filename = `avatar-${uuid.v1()}.png`;
        const filepath = this.filepath(filename);

        const image = await jimp.read(buffer);
        image.resize(720, jimp.AUTO)
            .write(filepath);

        return filename;
    }

    // func save avtar to folder /public/images
    async saveMapImage(roomId, buffer) {
        const filename = `map2d-${roomId}.png`;
        const filepath = this.filepath(filename);

        const image = await jimp.read(buffer);
        image.resize(720, jimp.AUTO)
            .write(filepath);

        return filename;
    }

    filepath(filename) {
        return path.resolve(`${this.folder}/${filename}`)
    }
}
module.exports = Resize;
