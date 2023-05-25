import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gas_detek/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  StatefulWidget rootScreen = const LoginScreen();

  void _getRootScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('current_user_uuid') != null) {
      rootScreen = const MainScreen();
    }
  }

  @override
  // ignore: no_logic_in_create_state
  _SplashScreenState createState() {
    _getRootScreen();
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  _SplashScreenState() {
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => widget.rootScreen),
            (route) => false);
      });
    });

    Timer(const Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).canvasColor,
            Theme.of(context).primaryColor
          ],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: const Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 200.0,
            width: 200.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2.0,
                    offset: const Offset(5.0, 3.0),
                    spreadRadius: 2.0,
                  )
                ]),
            child: const Center(
              child: ClipRRect(
                child: Icon(
                  Icons.car_rental_outlined,
                  size: 160,
                ), //put your logo here
              ),
            ),
          ),
        ),
      ),
    );
  }
}
