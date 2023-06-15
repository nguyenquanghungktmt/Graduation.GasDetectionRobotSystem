import firebase_admin
from firebase_admin import credentials, messaging

cred = credentials.Certificate("./gas-detekt-firebase-firebase-key.json")
firebase_admin.initialize_app(cred)

messaging.subscribe_to_topic

def send_notify_by_token(registration_token, title, body, dataObject=None):
    # See documentation on defining a message payload.
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body
        ),
        data=dataObject,
        token=registration_token,
    )

    # Send a message to the device corresponding to the provided
    # registration token.
    response = messaging.send(message)
    # Response is a message ID string.
    print('Successfully sent message:', response)


def send_notify_to_topic(topic, title, body, dataObject=None):
    # The topic name can be optionally prefixed with "/topics/".
    # See documentation on defining a message payload.
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body
        ),
        data={
            "isDisplayNotify": "0"
        },
        topic=topic,
    )

    # Send a message to the devices subscribed to the provided topic.
    response = messaging.send(message)
    # Response is a message ID string.
    print('Successfully sent message:', response)


def subcribe_to_topic():
    topic = 'highScores'
    # [START subscribe]
    # These registration tokens come from the client FCM SDKs.
    registration_tokens = [
        "fvrGQSiaRY61SQd3lXoGzL:APA91bEZVkgQQvSDN8NVDttDpII6f3SQKBDv4sFFegTd4R8QaAFaPezrBWdybBU7hd5wQYdzcVaOXKjgtmuSKcP6drj43GwjcWKB09lHFCperWbhyP3h_aMBGQjKRoY3hcTm_wHmGwwS"
    ]
    response = messaging.subscribe_to_topic(registration_tokens, topic)
    # See the TopicManagementResponse reference documentation
    # for the contents of response.
    print(response.success_count, 'tokens were subscribed successfully')