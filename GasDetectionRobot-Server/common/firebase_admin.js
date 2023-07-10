var firebase_admin = require("firebase-admin");
const serviceAccount = require("../config/push-notification-key.json");

/**
 * create firebase admin by cert file
 */
firebase_admin.initializeApp({
  credential: firebase_admin.credential.cert(serviceAccount)
})

module.exports.firebase_admin = firebase_admin