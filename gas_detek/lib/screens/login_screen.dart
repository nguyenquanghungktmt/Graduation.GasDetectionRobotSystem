import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gas_detek/common/theme_helper.dart';
import 'package:gas_detek/screens/main_screen.dart';

import '../common/loading/loading_screen.dart';
import 'registration_screen.dart';
import '../widgets/header_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double _headerHeight = 250;
  final Key _formKey = GlobalKey<FormState>();

  void _requestLogin() async {
     // Call LoadingScreen().show() to SHOW  Loading Dialog
    LoadingScreen().show(
      context: context,
      text: 'Please wait a moment',
    );

    // await for 2 seconds to Mock Loading Data
    await Future.delayed(const Duration(seconds: 2));
    
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()));

    // Call LoadingScreen().hide() to HIDE  Loading Dialog
    LoadingScreen().hide();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _headerHeight,
              // hungnq: set icon login page
              child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container( 
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                child: Column(
                  children: [
                    const Text(
                      'Gas Detekt',
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Connect to Robot',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextField(
                                decoration: ThemeHelper().textInputDecoration('User Name', 'Enter your user name'),
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            Container(
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextField(
                                obscureText: true,
                                decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10,0,10,20),
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  
                                },
                                child: const Text( "Forgot your password?", style: TextStyle( color: Colors.grey, ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                onPressed: _requestLogin,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text('Sign In'.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10,20,10,20),
                              //child: Text('Don\'t have an account? Create'),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(text: "Don\'t have an account? "),
                                    TextSpan(
                                      text: 'Create',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                                        },
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).canvasColor),
                                    ),
                                  ]
                                )
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );

  }
}