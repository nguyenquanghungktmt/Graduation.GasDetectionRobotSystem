module.exports = {
    /**
     * function getDatetimeNow get datetime in current
     * @returns string current datetime in GMT +7
     */
    getDatetimeNow: function (){
        let date = new Date()
        date.setHours(date.getHours() +7)
        return date.toISOString().slice(0, 19).replace('T', ' ');
    }
}