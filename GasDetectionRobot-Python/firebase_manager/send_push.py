import fcm_connection as fcm

token = "fvrGQSiaRY61SQd3lXoGzL:APA91bEZVkgQQvSDN8NVDttDpII6f3SQKBDv4sFFegTd4R8QaAFaPezrBWdybBU7hd5wQYdzcVaOXKjgtmuSKcP6drj43GwjcWKB09lHFCperWbhyP3h_aMBGQjKRoY3hcTm_wHmGwwS"

fcm.send_notify_by_token(token, "Hi", "This is my next msg")