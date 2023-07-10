const uuid = require("uuid")
const path = require('path');
const jimp = require('jimp');

/**
 * @class Resize: resize the image upload
 */
class Resize {

    constructor(folder) {
        this.folder = folder;
    }

    
    /**
     * func saveAvatar save the buffer of avatar image to folder /public/images
     * @param {ByteBuffer} buffer buffer data of image
     * @returns {String} filename of saved images
     */
    async saveAvatar(buffer) {
        const filename = `avatar-${uuid.v1()}.png`;
        const filepath = this.filepath(filename);

        const image = await jimp.read(buffer);
        image.resize(720, jimp.AUTO)
            .write(filepath);

        return filename;
    }

    
    /**
     * func saveMapImage save the buffer of map image to folder /public/images
     * @param {String} roomId room id of current scanning room
     * @param {ByteBuffer} buffer buiffer data of image
     * @returns {String} filename of saved images
     */
    async saveMapImage(roomId, buffer) {
        const filename = `map2d-${roomId}.png`;
        const filepath = this.filepath(filename);

        const image = await jimp.read(buffer);
        image.resize(720, jimp.AUTO)
            .write(filepath);

        return filename;
    }

    /**
     * func filepath make the filepath of file 
     * @param {String} filename filename that auto generate
     * @returns filepath of file
     */
    filepath(filename) {
        return path.resolve(`${this.folder}/${filename}`)
    }
}
module.exports = Resize;
