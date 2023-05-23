import 'package:gas_detek/common/alert_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("D'Info")),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const ListTile(title: Text('Dialog')),
          ElevatedButton(
            onPressed: () {
              Alert.dialogSuccess(context, 'Payment Success');
              Alert.closeDialog(context,
                  durationBeforeClose: const Duration(milliseconds: 500));
            },
            child: const Text('Success'),
          ),
          ElevatedButton(
            onPressed: () {
              Alert.dialogError(context, 'Payment Failed');
              Alert.closeDialog(context,
                  durationBeforeClose: const Duration(milliseconds: 500));
            },
            child: const Text('Fail Dialog'),
          ),
          ElevatedButton(
            onPressed: () async {
              bool? isYes = await Alert.dialogConfirmation(
                context,
                'Logout?',
                'You sure logout from this account?',
              );
              if (isYes ?? false) {
                print('user click yes');
              } else {
                print('user click no');
              }
            },
            child: const Text('Confirmation'),
          ),
          const Divider(),
          const ListTile(title: Text('Toast')),
          ElevatedButton(
            onPressed: () {
              Alert.toastError('Pick Color has Failed');
            },
            child: const Text('Error'),
          ),
          ElevatedButton(
            onPressed: () {
              Alert.toastSuccess('Login Success');
            },
            child: const Text('Success'),
          ),
          ElevatedButton(
            onPressed: () {
              Alert.toastNetral('Add to Cart');
            },
            child: const Text('Netral'),
          ),
          ElevatedButton(
            onPressed: () {
              Alert.closeToast();
            },
            child: const Text('Close Toast'),
          ),
          const Divider(),
          const ListTile(title: Text('Notif')),
          ElevatedButton(
            onPressed: () {
              Alert.notifError('Upload', "Fail upload image");
            },
            child: const Text('Error'),
          ),
          ElevatedButton(
            onPressed: () {
              Alert.notifSuccess('Login Success', 'Welcom Nguyen Hung !');
            },
            child: const Text('Success'),
          ),
          ElevatedButton(
            onPressed: () {
              Alert.notifNetral('Task', "You add new task");
            },
            child: const Text('Netral'),
          ),
          ElevatedButton(
            onPressed: () {
              Alert.closeNotif();
            },
            child: const Text('Close Notif'),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
