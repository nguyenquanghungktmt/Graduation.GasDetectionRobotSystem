import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gas_detek/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'screens/splash_screen.dart';
import 'package:gas_detek/constant.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void _registerNotification() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.instance.unsubscribeFromTopic(firebaseTopic);

  FirebaseMessaging.instance.getToken().then((token) async {
    // save to SP
    debugPrint('getToken: $token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('firebase_token') == null) {
      prefs.setString('firebase_token', token ?? "");
    }
  });

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //   print('main - onMessageOpenedApp');

  //   if (message.from == '/topics/$firebaseTopic') {
  //     return;
  //   }

  //   await NotificationService.showNotification(
  //     title: message.notification?.title ?? "",
  //     body: message.notification?.body ?? "",
  //   );

  //   // Navigator.pushNamed(navigatorKey.currentState!.context, '/room-detail',
  //   //     arguments: {'message', json.encode(message.data)});
  // });

  // FirebaseMessaging.instance
  //     .getInitialMessage()
  //     .then((RemoteMessage? message) async => {
  //           if (message != null)
  //             {
  //               await NotificationService.showNotification(
  //                 title: message.notification?.title ?? "",
  //                 body: message.notification?.body ?? "",
  //               )
  //               // Navigator.pushNamed(navigatorKey.currentState!.context, '/room-detail',
  //               // arguments: {'message', json.encode(message.data)});
  //             }
  //         });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackgroundHandler);
}

@pragma('vm:entry-point')
Future<void> _firebaseMessageBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  _registerNotification();
  runApp(const GasDetekApp());
}

class GasDetekApp extends StatelessWidget {
  const GasDetekApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: kLightBlue,
        canvasColor: kDarkBlue,
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(title: 'Gas Detection'),
      debugShowCheckedModeBanner: false, // bỏ cái thuộc tính debug
    );
  }
}
