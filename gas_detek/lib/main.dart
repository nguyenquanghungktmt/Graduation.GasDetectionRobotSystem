import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

import 'package:gas_detek/constant.dart';

void main() {
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
