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
        Alert.dialogError(
            context, 'Loading data failed\nPlease check your internet.');
        Alert.closeDialog(context,
            durationBeforeClose: const Duration(seconds: 2));

        // If the server did not return a 200 Success response, load data from db
        RoomDBHelper.getAllRooms().then((records) => {
              if (records != null)
                {
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

      // If the server did not return a 200 Success response, load data from db
      RoomDBHelper.getAllRooms().then((records) => {
            if (records != null)
              {
                setState(() {
                  _listRoom = records;
                  _totalRecord = records.length;
                })
              }
          });
    }
  }

  Future<void> _refresh() async {
    String? uuid = _user?.uuid;

    try {
      // call api get list room
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
      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        final data = body['data'];
        final items = data['items'];
        _totalRecord = data['total_record'];

        // Convert json data to list object
        final listRoomTmp =
            List.generate(items.length, (index) => Room.fromJson(items[index]));

        setState(() {
          _listRoom = listRoomTmp;
        });

        // Save to shared preference and realm db
        _saveListRoomData(listRoomTmp);
      } else {
        Alert.dialogError(context, 'Reloading data from internet failed.');
        Alert.closeDialog(context,
            durationBeforeClose: const Duration(seconds: 2));

        // load data from db
        RoomDBHelper.getAllRooms().then((records) => {
              if (records != null)
                {
                  setState(() {
                    _listRoom = records;
                    _totalRecord = records.length;
                  })
                }
            });
      }
    } on Exception {
      RoomDBHelper.getAllRooms().then((records) => {
            if (records != null)
              {
                setState(() {
                  _listRoom = records;
                  _totalRecord = records.length;
                })
              }
          });
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
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: kDarkBlue, size: 36),
        actions: [
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
        ],
      ),
      drawer: const SideMenu(),
      body: RefreshIndicator(
        strokeWidth: 2,
        color: kDarkBlue,
        backgroundColor: Colors.white,
        onRefresh: () => _refresh(),
        child: SingleChildScrollView(
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
      ),
    );
  }
}
