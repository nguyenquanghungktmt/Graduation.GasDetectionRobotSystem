module.exports = {
    createResponse: function (status, code, message, data=null){
        return {
            "status": status,
            "code": code,
            "message": message,
            "data": data
        };
    }
}