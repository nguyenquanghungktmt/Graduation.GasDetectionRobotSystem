const resizeImg = require('resize-image-buffer');
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

        await resizeImg(buffer,{
            width: 720,
            height: 720,
            })
            .toFile(filepath);

        return filename;
    }

    filepath(filename) {
        return path.resolve(`${this.folder}/${filename}`)
    }
}
module.exports = Resize;
