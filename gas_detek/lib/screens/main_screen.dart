// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously, must_be_immutable
import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gas_detek/common/enum_helper.dart';
import 'package:gas_detek/model/device_model.dart';
import 'package:gas_detek/model/room_model.dart';
import 'package:gas_detek/screens/room_detail_screen.dart';
import 'package:gas_detek/services/device_db_helper.dart';
import 'package:gas_detek/services/notification_service.dart';
import 'package:gas_detek/services/room_db_helper.dart';
import 'package:gas_detek/widgets/room_widget/room_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  StreamSubscription? _fcmListener;

  Future<void> _fetchData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String uuid = prefs.getString('current_user_uuid') ?? "";
    // print("uuid - $uuid");

    String? uuid = _user?.uuid;
    String? serialNumber = _user?.serialNumber;

    // get data from internet
    LoadingScreen().show(
      context: context,
      text: 'Loading...',
    );

    try {
      final results = await Future.wait([
        http.post(
          Uri.parse("$domain/room/getListRoom"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "owner_uuid": uuid ?? "",
          }),
        ),
        http.post(
          Uri.parse("$domain/device/getDeviceInfo"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "serial_number": serialNumber ?? "",
          }),
        ),
      ]);

      print(results[0].statusCode);
      LoadingScreen().hide();

      if (results[0].statusCode == 200) {
        // If the server did return a 200 CREATED response, then parse the JSON.
        final body = json.decode(results[0].body);

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

        // Convert json data in resp2 to device object
        final bodyResp2 = json.decode(results[1].body);
        final deviceData = bodyResp2['data'];
        final deviceObject = Device.fromJson(deviceData);

        // Save to shared preference and realm db
        _saveListRoomData(listRoomTmp, deviceObject);
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
    String? serialNumber = _user?.serialNumber;

    try {
      // call api get list room
      final results = await Future.wait([
        http.post(
          Uri.parse("$domain/room/getListRoom"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "owner_uuid": uuid ?? "",
          }),
        ),
        http.post(
          Uri.parse("$domain/device/getDeviceInfo"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "serial_number": serialNumber ?? "",
          }),
        ),
      ]);

      print(results[0].statusCode);
      print(results[1].statusCode);
      if (results[0].statusCode == 200 || results[1].statusCode == 200) {
        final body = json.decode(results[0].body);

        final data = body['data'];
        final items = data['items'];
        _totalRecord = data['total_record'];

        // Convert json data to list object
        final listRoomTmp =
            List.generate(items.length, (index) => Room.fromJson(items[index]));

        setState(() {
          _listRoom = listRoomTmp;
        });

        // Convert json data in resp2 to device object
        final bodyResp2 = json.decode(results[1].body);
        final deviceData = bodyResp2['data'];
        final deviceObject = Device.fromJson(deviceData);

        // Save to shared preference and realm db
        _saveListRoomData(listRoomTmp, deviceObject);
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

  Future<void> _requestUpdateRoom(Room updatedRoom) async {
    LoadingScreen().show(
      context: context,
      text: 'Updating...',
    );

    // request update room name
    try {
      String apiUrl = "$domain/room/updateRoom";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "room_id": updatedRoom.roomId,
          "room_name": updatedRoom.roomName,
          "is_gas_detect": '${updatedRoom.isGasDetect}',
          "room_status": updatedRoom.roomStatus
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

        if (status == 1 && code == 200) {
          // delete room success
          // delete in db local
          RoomDBHelper.updateRoom(updatedRoom);

          // refresh state
          setState(() {
            var index = _listRoom
                ?.indexWhere((element) => element.roomId == updatedRoom.roomId);
            if (index != null) {
              _listRoom?[index] = updatedRoom;
            }
          });

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

        Alert.toastError('Update room failed');
        Alert.closeToast(
            durationBeforeClose: const Duration(milliseconds: 1500));
      }
    } on Exception {
      // catch exception
      LoadingScreen().hide();
      Alert.toastError('Server error!');
      Alert.closeToast(durationBeforeClose: const Duration(milliseconds: 1500));
    }
  }

  Future<void> _requestDeleteRoom(Room room) async {
    // request delete room
    try {
      String apiUrl = "$domain/room/deleteRoom";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "room_id": room.roomId,
          "owner_uuid": room.ownerUUID,
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
          // delete room success
          // delete in db local
          RoomDBHelper.deleteRoom(room);

          // refresh state
          setState(() {
            _totalRecord--;
            _listRoom?.remove(room);
          });

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

        Alert.toastError('Delete room failed');
        Alert.closeToast(
            durationBeforeClose: const Duration(milliseconds: 1500));
      }
    } on Exception {
      // catch exception

      Alert.toastError('Server error!');
      Alert.closeToast(durationBeforeClose: const Duration(milliseconds: 1500));
    }
  }

  Future<void> _requestCreateRoom(String userUUID) async {
    LoadingScreen().show(
      context: context,
      text: 'Please wait a moment',
    );

    if (userUUID.isEmpty) {
      LoadingScreen().hide();
      Alert.dialogError(context, "User is null.\nCannot create new room.");
      Alert.closeDialog(context,
          durationBeforeClose: const Duration(seconds: 1));
    }

    try {
      String apiUrl = "$domain/room/createRoom";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{"owner_uuid": userUUID}),
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
          Room room = Room.fromJson(data);

          setState(() {
            _totalRecord++;
            _listRoom?.add(room);
          });

          // Save to sqflite db
          RoomDBHelper.addRoom(room);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RoomDetail(
                        room: room,
                        updateRoom: (room) => _requestUpdateRoom(room),
                      )));

          Alert.toastSuccess("Created new room");
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

        Alert.dialogError(context, 'Create Room Failed');
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

  Future<void> _saveListRoomData(List<Room> rooms, Device device) async {
    // RoomDBHelper
    RoomDBHelper.deleteAllRooms();
    rooms.forEach((element) {
      RoomDBHelper.addRoom(element);
    });

    // Save device object
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('device_serial_number', device.serialNumber);
    DeviceDBHelper.addDevice(device);
  }

  Future<void> _initializeFCM() async {
    // await FirebaseMessaging.instance
    //     .subscribeToTopic(firebaseTopic)
    //     .then((value) => print("Firebase subcribe topic $firebaseTopic"));

    _fcmListener =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Got a message whilst in the foreground!');
      final data = message.data;

      final target = EnumTargetHelper.parse(data['target']);
      switch (target) {
        case Target.room:
          // Update for list room
          debugPrint("Receive push notify update list_room");
          final roomId = data['room_id'];
          final isGasDetect = data['is_gas_detect'];
          final roomStatus = data['room_status'];

          var index =
              _listRoom?.indexWhere((element) => element.roomId == roomId);
          if (index != null) {
            setState(() {
              _listRoom?[index].isGasDetect = int.parse(isGasDetect);
              _listRoom?[index].roomStatus = roomStatus;
            });

            // update in DB local
            RoomDBHelper.updateRoom(_listRoom![index]);
          }

          final title = message.notification?.title ?? "";
          final body = message.notification?.body ?? "";
          await NotificationService.showNotification(
            title: title,
            body: "$body -- index = $isGasDetect",
          );
          break;

        case Target.general:
          await NotificationService.showNotification(
            title: message.notification?.title ?? "",
            body: message.notification?.body ?? "",
          );
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
    _initializeFCM();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if (_fcmListener != null) {
      _fcmListener!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Gas Detection",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kDarkBlue,
        iconTheme: const IconThemeData(color: Colors.white, size: 36),
        // flexibleSpace:Container(
        //   decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //           begin: Alignment.topLeft,
        //           end: Alignment.bottomRight,
        //           colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).canvasColor,]
        //       )
        //   ),
        // ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey.shade500,
            height: 0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _requestCreateRoom(_user?.uuid ?? ""),
            icon: const Icon(
              Icons.add,
              size: 36,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {},
      //   backgroundColor: Colors.blue.shade400,
      //   child: const Icon(
      //     Icons.add_rounded,
      //     color: Colors.white,
      //     size: 40.0,
      //   )
      // ),
      drawer: const SideMenu(),
      body: RefreshIndicator(
        strokeWidth: 2,
        color: kDarkBlue,
        backgroundColor: Colors.white,
        onRefresh: () => _refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  listRoom: (_listRoom ?? []).reversed.toList(),
                  totalRoom: _totalRecord,
                  deleteRoom: (room) => _requestDeleteRoom(room),
                  updateRoom: (room) => _requestUpdateRoom(room),
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
