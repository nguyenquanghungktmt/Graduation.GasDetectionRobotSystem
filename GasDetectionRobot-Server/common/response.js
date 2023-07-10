module.exports = {
    /**
     * function createResponse create the json response for api request
     * @param {Number} status value in {0, 1} shơ the problem from server (0) or client(1)
     * @param {Number} code response code like 200, 201, 400, 404, ... 
     * @param {String} message string message response
     * @param {any} data Any data object server send back to client. Default value null
     * @returns json response
     */
    createResponse: function (status, code, message, data=null){
        return {
            "status": status,
            "code": code,
            "message": message,
            "data": data
        };
    }
}