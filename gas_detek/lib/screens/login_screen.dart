// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gas_detek/common/theme_helper.dart';
import 'package:gas_detek/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../common/loading/loading_screen.dart';
import '../common/alert_helper.dart';
import '../model/user_model.dart';
import '../services/user_db_helper.dart';
import 'registration_screen.dart';
import '../widgets/header_widget.dart';
import '../constant.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double _headerHeight = 250;
  final Key _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _saveData(User user) async {
    // Save uuid to shared preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('current_user_uuid', user.uuid);

    // save user object ro realm db
    UserDBHelper.addUser(user);
  }

  void _requestLogin() async {
    String username = _userNameController.text;
    String password = _passwordController.text;

    // Call LoadingScreen().show() to show Loading Dialog
    LoadingScreen().show(
      context: context,
      text: 'Please wait a moment',
    );

    try {
      String apiUrl = "$domain/login";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username": username,
          "password": password,
        }),
      );

      print(response.statusCode);
      LoadingScreen().hide();

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response, then parse the JSON.
        final body = json.decode(response.body);

        final status = body['status'] as int;
        final code = body['code'] as int;
        final message = body['message'] as String;
        final data = body['data'];

        if (status == 1 && (code == 200 || code == 201)) {
          User user = User.fromJson(data);

          // TODO: save to shared preference and realm db
          _saveData(user);

          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => MainScreen(user: user)), (route) => false);
          Alert.toastSuccess(message);
          Alert.closeToast(
              durationBeforeClose: const Duration(milliseconds: 1500));
        } else {
          Alert.dialogError(context, message);
          Alert.closeDialog(context,
              durationBeforeClose: const Duration(seconds: 1));
        }
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        Alert.dialogError(context, 'Login Failed');
        Alert.closeDialog(context,
            durationBeforeClose: const Duration(seconds: 1));
      }
    } on Exception {
      // catch exception
      LoadingScreen().hide();

      Alert.dialogError(context, 'Error');
      Alert.closeDialog(context,
          durationBeforeClose: const Duration(milliseconds: 1500));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      const Text(
                        'Gas Detekt',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
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
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextField(
                                  controller: _userNameController,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'User Name', 'Enter your user name'),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Container(
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Password', 'Enter your password'),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    "Forgot your password?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  onPressed: _requestLogin,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      'Sign In'.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  const TextSpan(
                                      text: "Don\'t have an account? "),
                                  TextSpan(
                                    text: 'Create',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RegistrationScreen()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).canvasColor),
                                  ),
                                ])),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
