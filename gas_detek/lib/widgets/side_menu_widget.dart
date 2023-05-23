// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gas_detek/screens/login_screen.dart';
import 'package:ternav_icons/ternav_icons.dart';

import '../common/alert_helper.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  Future<void> _logout(BuildContext context) async{
    bool? isYes = await Alert.dialogConfirmation(
      context,
      'Logout?',
      'You sure logout from this account?',
    );
    if (isYes ?? false) {
      Alert.toastSuccess('Logout Success');
      Alert.closeToast(durationBeforeClose: const Duration(milliseconds: 1500));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false
      );
    }
  }

  Future<void> _aboutUs(BuildContext context) async{
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
            title: "Overview",
            onTap: () {},
          ),
          DrawerListTile(
            icon: TernavIcons.lightOutline.user_2,
            title: "User",
            onTap: () {},
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
