import fcm_connection as fcm

# The topic name can be optionally prefixed with "/topics/".
topic = 'connect-device-app'

fcm.send_notify_to_topic(topic, 'Title Notify Topic', 'Body Notify Topic')