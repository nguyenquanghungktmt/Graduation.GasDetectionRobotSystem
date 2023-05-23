// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gas_detek/common/theme_helper.dart';
import 'package:gas_detek/widgets/header_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;

import '../common/alert_helper.dart';
import '../common/loading/loading_screen.dart';
import '../constant.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool checkedValue = false;
  bool checkboxValue = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  File? _avatar;

  Future getAvatarImage() async {
    XFile? image;

    try {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    } on PlatformException {
      image = null;
    }

    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _avatar = imageTemporary;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailAddressController.dispose();
    _serialNumberController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get serial number.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        _serialNumberController.text = "";
      } else {
        _serialNumberController.text = barcodeScanRes;
        Vibration.vibrate(duration: 200);
      }
    });
  }

  Future<void> requestRegister() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String userName = _userNameController.text;
    String email = _emailAddressController.text;
    String serialNumber = _serialNumberController.text;
    String password = _passwordController.text;

    LoadingScreen().show(
      context: context,
      text: 'Please wait a moment',
    );

    try {
      String apiUrl = "$domain/register";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "user_name": userName,
          "serial_number": serialNumber,
          "password": password,
        }),
      );

      // print(response.runtimeType);
      print(response.statusCode);
      // print(response.body);

      LoadingScreen().hide();
      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        print(response.body);

        Alert.dialogSuccess(context, 'Registration Success');
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        Alert.dialogError(context, 'Registration Failed');
      }
      Alert.closeDialog(context, durationBeforeClose: const Duration(seconds: 1));
    } on Exception {
      // print("SocketException");
      LoadingScreen().hide();
      
      Alert.dialogError(context, 'Error');
      Alert.closeDialog(context, durationBeforeClose: const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const SizedBox(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      border: Border.all(
                                          width: 5, color: Colors.white),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(5, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: _avatar != null
                                          ? Image.file(_avatar!,
                                              width: 80.0,
                                              height: 80.0,
                                              fit: BoxFit.cover)
                                          : Icon(
                                              Icons.person,
                                              color: Colors.grey.shade300,
                                              size: 80.0,
                                            ),
                                    )),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(60, 55, 0, 0),
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.grey.shade700,
                                  ),
                                  onPressed: () => getAvatarImage(),
                                  iconSize: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: ThemeHelper().textInputDecoration(
                                'First Name*', 'Enter your first name'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your first name";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: ThemeHelper().textInputDecoration(
                                'Last Name*', 'Enter your last name'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your last name";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _userNameController,
                            decoration: ThemeHelper().textInputDecoration(
                                'User Name*', 'Enter your user name'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your user name";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _emailAddressController,
                            decoration: ThemeHelper().textInputDecoration(
                                "E-mail address*", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if ((val!.isEmpty) ||
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                return "Enter valid email address";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _serialNumberController,
                            decoration: ThemeHelper()
                                .textInputDecorationWithQRScan(
                                    "Robot Serial Number*",
                                    "XXXXXXXXXX",
                                    () => scanQR()),
                            validator: (val) {
                              if (val!.isEmpty ||
                                  !RegExp(r"^[a-zA-Z0-9]{10}]*$")
                                      .hasMatch(val)) {
                                return "Enter valid serial number";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password*", "Enter your password"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    const Text(
                                      "I accept all terms and conditions.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              requestRegister();
                              // requestRegister();
                              // if (_formKey.currentState!.validate()) {
                              // Navigator.of(context).pushAndRemoveUntil(
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const ProfilePage()),
                              //     (Route<dynamic> route) => false);
                              // }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
