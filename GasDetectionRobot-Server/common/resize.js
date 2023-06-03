const sharp = require('sharp');
const uuid = require("uuid")
const path = require('path');

class Resize {
    constructor(folder) {
        this.folder = folder;
    }

    // func save avtar to folder /public/images
    async saveAvatar(buffer) {
        const filename = `avatar-${uuid.v1()}.png`;
        const filepath = this.filepath(filename);

        await sharp(buffer)
            .resize(720, 720, { // size image 300x300
            fit: sharp.fit.inside,
            withoutEnlargement: true
            })
            .toFile(filepath);

        return filename;
    }

    filepath(filename) {
        return path.resolve(`${this.folder}/${filename}`)
    }
}
module.exports = Resize;
