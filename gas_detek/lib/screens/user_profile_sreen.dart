// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gas_detek/common/alert_helper.dart';
import 'package:gas_detek/model/user_model.dart';
import 'package:gas_detek/screens/login_screen.dart';
import 'package:gas_detek/services/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class UserProfile extends StatefulWidget {
  final User user;
  const UserProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfile> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _saveImage(String url) async {
    try {
      await GallerySaver.saveImage(
        url,
        albumName: 'Flutter',
      ).then((success) {
        String message = 'Save failed';
        if (success ?? false) {
          message = 'Image saved';
        }

        Alert.toastSuccess(message);
        Alert.closeToast(
            durationBeforeClose: const Duration(milliseconds: 1500));
      });
    } catch (e) {
      Alert.toastSuccess('Save failed');
      Alert.closeToast(durationBeforeClose: const Duration(milliseconds: 1500));
    }
  }

  Future<void> _requestDeleteAccount(User user) async {
    // request delete account user
    try {
      String apiUrl = "$domain/deleteAccount";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "user_uuid": user.uuid,
        }),
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response, then parse the JSON.
        final body = json.decode(response.body);

        final status = body['status'] as int;
        final code = body['code'] as int;
        final message = body['message'] as String;

        if (status == 1 && code == 200) {
          // delete account success, back to login screen

          // Delete local Sqflite Database, pref
          SharedPreferences prefs = await SharedPreferences.getInstance();
          for(String key in prefs.getKeys()) {
            if (key != 'firebase_token') prefs.remove(key);
          }
          DatabaseHelper.deleteDB();

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false);

          Alert.toastSuccess(message);
          Alert.closeToast(
              durationBeforeClose: const Duration(milliseconds: 1500));
        } else {
          // delete faild
          Alert.toastError(message);
          Alert.closeToast(
              durationBeforeClose: const Duration(milliseconds: 1500));
        }
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        Alert.toastError('Delete account failed');
        Alert.closeToast(
            durationBeforeClose: const Duration(milliseconds: 1500));
      }
    } on Exception {
      // catch exception

      Alert.toastError('Server error!');
      Alert.closeToast(durationBeforeClose: const Duration(milliseconds: 1500));
    }
  }

  Future<void> _deleteAccount(User user) async {
    bool? isYes = await Alert.dialogConfirmation(
      context,
      'Delete cccount?',
      'Are you sure delete this account?',
    );
    if (isYes ?? false) {
      _requestDeleteAccount(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    String avatarUrl = "$domain/images/${_user.avatarUrl}";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kDarkBlue,
        iconTheme: const IconThemeData(color: Colors.white, size: 36),
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(4.0),
        //   child: Container(
        //     color: Colors.grey,
        //     height: 0.5,
        //   ),
        // ),
        actions: [
          PopupMenuButton(
              icon: const Icon(
                Icons.more_vert_outlined,
                size: 36,
                color: Colors.white,
              ),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    padding: EdgeInsets.only(right: 10, left: 20),
                    value: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Save Avatar'),
                        SizedBox(width: 5),
                        Icon(Icons.save_alt_outlined,
                            size: 20, color: Colors.black87),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                      padding: EdgeInsets.only(right: 10, left: 20),
                      value: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delete Account',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.delete_rounded,
                              size: 20, color: Colors.red),
                        ],
                      )),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 0:
                    // print("Save Avatar selected.");
                    _saveImage(avatarUrl);
                    break;
                  case 1:
                    _deleteAccount(_user);
                    break;
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        // physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container avatar image
            Container(
                height: maxWidth * 0.5,
                width: maxWidth,
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                decoration: BoxDecoration(
                  color: kDarkBlue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 6.0),
                  ),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size(120.0, 120.0),
                      // Image radius
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.network(avatarUrl,
                            errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            color: Colors.grey.shade300,
                            size: 100.0,
                          );
                        }),
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 40.0),

            // Username
            Container(
              width: maxWidth - 30.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Username",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    Text(
                      _user.username,
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // full name
            Container(
              width: maxWidth - 30.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fullname",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    Text(
                      _user.getFullName(),
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // email
            Container(
              width: maxWidth - 30.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    Text(
                      _user.email,
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
