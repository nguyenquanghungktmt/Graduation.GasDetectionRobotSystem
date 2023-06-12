import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTConnectionHelper {
  static const host = 'gas-detekt-iot-hub.azure-devices.net';
  static const port = 8883;
  static const deviceId = 'RB23GD1708';
  static const username =
      'gas-detekt-iot-hub.azure-devices.net/RB23GD1708/?api-version=2021-04-12';
  static const password =
      'SharedAccessSignature sr=gas-detekt-iot-hub.azure-devices.net%2Fdevices%2FRB23GD1708&sig=XofOELyukgQGePm7M9hxRCAX5Bw0v6llreuhdByeJQg%3D&se=1686592908';

  static const publicTopic = 'devices/$deviceId/messages/events/';

  static Future<int> connectMQTT() async {
    final client = MqttServerClient.withPort(host, deviceId, port);

    client.logging(on: false);
    client.setProtocolV311();
    client.keepAlivePeriod = 20;
    client.secure = true;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(deviceId)
        .authenticateAs(username, password)
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;

    print('client connecting..............');
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print('client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      print('socket exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('client connected');
    } else {
      print(
          'client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }

    print('Subscribing to the $publicTopic topic');
    client.subscribe(publicTopic, MqttQos.atMostOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Received message: topic is ${c[0].topic}, payload is $pt');
    });

    return 0;
  }
}

/// The unsolicited disconnect callback
void onDisconnected() {
  print('====================');
  print('*** OnDisconnected client callback - Client disconnection');
  exit(-1);
}

/// The successful connect callback
void onConnected() {
  print('====================');
  print('*** OnConnected client callback - Client connection was sucessful');
}

/// Pong callback
void pong() {
  print('Ping response client callback invoked');
}

/// The subscribed callback
void onSubscribed(String topic) {
  print('Subscription confirmed for topic $topic');
}

Future<int> main() async {
  MQTTConnectionHelper.connectMQTT();
  return 0;
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
