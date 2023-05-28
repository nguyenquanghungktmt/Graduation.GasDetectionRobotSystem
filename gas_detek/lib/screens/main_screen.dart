// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously
import 'dart:convert';

import 'package:gas_detek/model/room_model.dart';
import 'package:gas_detek/widgets/room_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../common/loading/loading_screen.dart';
import '../constant.dart';
import '../widgets/side_menu_widget.dart';
import '../common/alert_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  List<Room> listRoom = [];

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('current_user_uuid') ?? "";
    print("uuid - $uuid");

    // get data from internet
    LoadingScreen().show(
      context: context,
      text: 'Loading...',
    );

    try {
      String apiUrl = "$domain/getListRoom";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "owner_uuid": uuid,
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
          // Convert json data to list object
          listRoom = List.generate(data.length, (index) => Room.fromJson(data[index]));

          // TODO: save to shared preference and realm db
          _saveListRoomData();
        } else {
          Alert.dialogError(context, message);
          Alert.closeDialog(context,
              durationBeforeClose: const Duration(seconds: 1));
        }
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        Alert.dialogError(context, 'Loading Data Failed');
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

  Future<void> _saveListRoomData() async {
    return;
  }

  @override
  Widget build(BuildContext context) {
    _fetchData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Gas Detection",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.grey, size: 36),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.notifications,
          //     color: Colors.grey,
          //   ),
          // ),
          IconButton(
            onPressed: () {
              print("add scan room");
            },
            icon: const Icon(
              Icons.add,
              color: Colors.grey,
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
          //   child: const CircleAvatar(
          //     backgroundImage: NetworkImage(
          //         "https://images.unsplash.com/photo-1500522144261-ea64433bbe27?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTh8fHdvbWVufGVufDB8MHwwfHw%3D&auto=format&fit=crop&w=500&q=60"),
          //   ),
          // )
        ],
      ),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                text: const TextSpan(
                  text: "Hello ",
                  style: TextStyle(color: kDarkBlue, fontSize: 20),
                  children: [
                    TextSpan(
                      text: "Nguyen Hung",
                      style: TextStyle(
                          color: kDarkBlue, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ", welcome back!",
                    ),
                  ],
                ),
              ),
              // cách ra một khoảng
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 50,
                child: Text(
                  "My Rooms",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const RoomGrid(),
              // const SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
