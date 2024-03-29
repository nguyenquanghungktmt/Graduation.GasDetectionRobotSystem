const winston = require("winston");
const path = require("path");

/**
 * set timezone to Asia/Ho_Chi_Minh
 */
const timezoned = () => {
  return new Date().toLocaleString('en-US', {
      timeZone: 'Asia/Ho_Chi_Minh'
  });
}

/**
 * winston logger configuration
 * levels: fatal, error, warning, info, debug
 * export a module logger
 */
module.exports = winston.createLogger({
  // Combine the format of log
  format: winston.format.combine(
    winston.format.splat(),
    // Time format for log
    winston.format.timestamp({
      format: "YYYY-MM-DD HH:mm:ss",
      format: timezoned
    }),

    // set the format of log
    winston.format.printf((log) => {
      // if log is error then display stack trace otherwise not show log message
      if (log.stack)
        return `[${log.timestamp}][${log.level.toUpperCase()}] ${log.stack}`;
      else
        return `[${log.timestamp}][${log.level.toUpperCase()}] ${log.message}`;
    })
  ),
  transports: [
    // Display log through console
    new winston.transports.Console(),

    // Set to write logs to the file
    new winston.transports.File({
      filename: path.resolve(__dirname, '..') + "/logs/logging.log",
    }),
  ],
});
