// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gas_detek/common/loading/loading_screen.dart';
import 'package:gas_detek/screens/login_screen.dart';
import 'package:gas_detek/screens/user_profile_sreen.dart';
import 'package:gas_detek/services/database_helper.dart';
import 'package:gas_detek/services/user_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ternav_icons/ternav_icons.dart';
import 'package:http/http.dart' as http;

import '../common/alert_helper.dart';
import '../constant.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  void _requestLogout(BuildContext context) async {
    // Call LoadingScreen().show() to show Loading Dialog
    LoadingScreen().show(context: context, text: 'Logout...');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final uuid = prefs.getString('current_user_uuid');

      String apiUrl = "$domain/logout";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "uuid": uuid ?? "",
        }),
      );

      print(response.statusCode);
      LoadingScreen().hide();

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response, then parse the JSON.
        final body = json.decode(response.body);
        final message = body['message'] as String;

        // Delete local Sqflite Database, pref 
        // Except firebase_token
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
        Alert.dialogError(context, 'Logout Failed');
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

  Future<void> _logout(BuildContext context) async {
    bool? isYes = await Alert.dialogConfirmation(
      context,
      'Logout?',
      'You sure logout from this account?',
    );
    if (isYes ?? false) {
      _requestLogout(context);
    }
  }

  Future<void> _userTapped(BuildContext context) async {
    // get the uuid
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uuid = prefs.getString('current_user_uuid') ?? "";

    UserDBHelper.getUser(uuid).then((user) => {
          if (user != null)
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfile(user: user)))
        });
  }

  Future<void> _aboutUs(BuildContext context) async {
    Alert.dialogNotification(
      context,
      'About Us',
      'This application created by Nguyễn Quang Hưng.\nAll right reserved.\nVersion: 1.2.6',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width / 1.75,
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 150,
            child: DrawerHeader(
                child: Image.asset(
              "assets/images/help.png",
            )),
          ),
          DrawerListTile(
            icon: TernavIcons.lightOutline.home_2,
            title: "Dashboard",
            onTap: () {
              Navigator.pop(context);
            },
          ),
          DrawerListTile(
            icon: TernavIcons.lightOutline.user_2,
            title: "User",
            onTap: () => _userTapped(context),
          ),
          DrawerListTile(
            icon: TernavIcons.lightOutline.info_1,
            title: "About us",
            onTap: () => _aboutUs(context),
          ),
          DrawerListTile(
            icon: TernavIcons.lightOutline.logout,
            title: "Log out",
            onTap: () => _logout(context),
          ),
          const SizedBox(
            height: 60,
          ),
          // Image.asset(
          //   "assets/images/help.png",
          //   height: 150,
          // ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: -10,
      leading: Icon(
        icon,
        color: Colors.grey,
        size: 18,
      ),
      dense: true,
      title: Text(
        title,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
