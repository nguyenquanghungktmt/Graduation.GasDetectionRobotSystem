// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously, must_be_immutable
import 'dart:convert';

import 'package:gas_detek/model/room_model.dart';
import 'package:gas_detek/services/room_db_helper.dart';
import 'package:gas_detek/widgets/room_widget/room_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../common/loading/loading_screen.dart';
import '../constant.dart';
import '../model/user_model.dart';
import '../widgets/side_menu_widget.dart';
import '../common/alert_helper.dart';

class MainScreen extends StatefulWidget {
  User? user;
  MainScreen({Key? key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  User? _user;
  List<Room>? _listRoom;
  int _totalRecord = 0;

  Future<void> _fetchData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String uuid = prefs.getString('current_user_uuid') ?? "";
    // print("uuid - $uuid");

    String? uuid = _user?.uuid;

    // get data from internet
    LoadingScreen().show(
      context: context,
      text: 'Loading...',
    );

    try {
      String apiUrl = "$domain/room/getListRoom";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "owner_uuid": uuid ?? "",
        }),
      );

      print(response.statusCode);
      LoadingScreen().hide();

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response, then parse the JSON.
        final body = json.decode(response.body);

        // final status = body['status'] as int;
        // final code = body['code'] as int;
        // final message = body['message'] as String;
        final data = body['data'];
        final items = data['items'];
        _totalRecord = data['total_record'];

        // Convert json data to list object
        final listRoomTmp =
            List.generate(items.length, (index) => Room.fromJson(items[index]));
        // print(listRoom?.length);
        // print(listRoom);

        setState(() {
          _listRoom = listRoomTmp;
        });

        // Save to shared preference and realm db
        _saveListRoomData(listRoomTmp);
      } else {
        Alert.dialogError(context, 'Loading Data Failed\nPlease check your internet.');
        Alert.closeDialog(context,
            durationBeforeClose: const Duration(seconds: 2));

        // If the server did not return a 200 Success response, load data from db
        // TODO: load data
        RoomDBHelper.getAllRooms().then((records) => {
          if (records != null) {
            setState(() {
              _listRoom = records;
              _totalRecord = records.length;
            })
          }
        });
      }
    } on Exception {
      // catch exception
      LoadingScreen().hide();

      Alert.dialogError(context, 'Error');
      Alert.closeDialog(context,
          durationBeforeClose: const Duration(milliseconds: 1500));
    }
  }

  Future<void> _saveListRoomData(List<Room>? rooms) async {
    // RoomDBHelper
    if (rooms == null) return;
    RoomDBHelper.deleteAllRooms();
    rooms.forEach((element) {
      RoomDBHelper.addRoom(element);
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Gas Detection",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: kDarkBlue, size: 36),
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
              size: 36,
              color: kDarkBlue,
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
                text: TextSpan(
                  text: "Hello ",
                  style: const TextStyle(color: kDarkBlue, fontSize: 20),
                  children: [
                    TextSpan(
                      text: (_user != null) ? _user!.getFullName() : "",
                      style: const TextStyle(
                          color: kDarkBlue, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
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
              RoomGrid(
                listRoom: _listRoom ?? [],
                totalRoom: _totalRecord,
              ),
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
