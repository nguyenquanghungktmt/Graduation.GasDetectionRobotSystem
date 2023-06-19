// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gas_detek/common/alert_helper.dart';
import 'package:gas_detek/common/loading/loading_screen.dart';
import 'package:gas_detek/model/device_model.dart';
import 'package:gas_detek/model/room_model.dart';
import 'package:gas_detek/screens/device_info_screen.dart';
import 'package:gas_detek/services/device_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

class RoomDetail extends StatefulWidget {
  final Room room;
  final void Function(Room) updateRoom;
  const RoomDetail({Key? key, required this.room, required this.updateRoom})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RoomDetailState();
  }
}

class _RoomDetailState extends State<RoomDetail> {
  late Room _room;
  late Device? _device;
  String _roomName = "";
  String _robotName = "";
  String _robotSN = "";
  bool _isConnectA2D = false;

  final TextEditingController _roomNameController = TextEditingController();

  // late StreamSubscription _fcmListener;

  Future<void> _fetchDataRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final serialNumber = prefs.getString('device_serial_number');
    if (serialNumber != null) {
      DeviceDBHelper.getDevice(serialNumber).then((device) => setState(() {
            if (device != null) {
              _device = device;
              _robotName = device.modelName;
              _robotSN = device.serialNumber;
            }
          }));
    }
  }

  Future<void> _requestConnectA2D() async {
    // Call LoadingScreen().show() to show Loading Dialog
    LoadingScreen().show(
      context: context,
      text: 'Please wait a moment',
    );

    try {
      String apiUrl = "$domain/pingConnectA2D";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          "user_uuid": _room.ownerUUID,
          "room_id": _room.roomId,
          "device_serial_number": _robotSN
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

        if (status == 1 && code == 200 ) {
          setState(() {
            _isConnectA2D = true;
          });
          Alert.dialogSuccess(context, message);
          Alert.closeDialog(context,
              durationBeforeClose: const Duration(seconds: 1));
        } else {
          Alert.dialogError(context, message);
          Alert.closeDialog(context,
              durationBeforeClose: const Duration(milliseconds: 1500));
        }
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        Alert.dialogError(context, 'Connect failed');
        Alert.closeDialog(context,
            durationBeforeClose: const Duration(milliseconds: 1500));
      }
    } on Exception {
      // catch exception
      LoadingScreen().hide();

      Alert.dialogError(context, 'Connect error');
      Alert.closeDialog(context,
          durationBeforeClose: const Duration(milliseconds: 1500));
    }
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

  void _updateRoomName() {
    setState(() {
      _roomName = _roomNameController.text;
    });
  }

  Future<void> _saveRoom() async {
    if (_roomName == _room.roomName) {
      return Navigator.pop(context);
    }

    bool? isYes = await Alert.dialogConfirmation(
      context,
      'Save Update?',
      'You sure update edit this room?',
    );
    if (isYes ?? false) {
      // back to main screen
      Navigator.pop(context);

      // update room with new name
      final newRoom = Room(
          roomId: _room.roomId,
          roomName: _roomName,
          ownerUUID: _room.ownerUUID,
          isGasDetect: _room.isGasDetect,
          roomStatus: _room.roomStatus);
      widget.updateRoom(newRoom);
    }
  }

  /*
  Future<void> _initializeFCM() async {
    await FirebaseMessaging.instance
        .subscribeToTopic(firebaseTopic)
        .then((value) => print("Firebase subcribe topic $firebaseTopic"));

    _fcmListener = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('message: $message');
    });
  }
  */

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _roomName = _room.roomName;
    _roomNameController.text = _room.roomName;
    _roomNameController.addListener(_updateRoomName);
    // _initializeFCM();
    _fetchDataRoom();
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    // _fcmListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    String map2dUrl = "$domain/images/${_room.map2dUrl}";
    // String map2dUrl = 'https://raspberrypi.vn/wp-content/uploads/2016/10/raspberry_pi_3.jpg';

    return WillPopScope(
      onWillPop: () async {
        // FirebaseMessaging.instance.unsubscribeFromTopic(firebaseTopic);
        _saveRoom();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            _roomName,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: kDarkBlue,
          iconTheme: const IconThemeData(color: Colors.white, size: 36),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 0.5,
            ),
          ),
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.check_rounded,
            //     size: 36,
            //     color: Colors.white,
            //   ),
            // ),
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
                          Text('Save Room'),
                          SizedBox(width: 5),
                          Icon(Icons.check_outlined,
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
                          Text('Save Map 2D'),
                          SizedBox(width: 5),
                          Icon(Icons.save_alt_outlined,
                              size: 20, color: Colors.black87),
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      debugPrint("Save Room selected.");
                      _saveRoom();
                      break;
                    case 1:
                      debugPrint("Save Image selected.");
                      _saveImage(map2dUrl);
                      break;
                  }
                }),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // container room name
                Container(
                  height: 50.0,
                  width: maxWidth - 20.0,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.3),
                    //     spreadRadius: 2,
                    //     blurRadius: 10,
                    //     offset: const Offset(2, 2),
                    //   ),
                    // ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Name: ',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600),
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: _roomNameController,
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: kDarkBlue), //<-- SEE HERE
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // container room status
                Container(
                    height: 28.0,
                    width: maxWidth - 20.0,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                    ),
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                            text: 'Status: ',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: _room.roomStatus,
                            style: TextStyle(
                                color: _room.isGasDetect == 1
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400))
                      ]),
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                // create box information about robot
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
                    padding: const EdgeInsets.fromLTRB(15, 15, 5, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Robot: $_robotName",
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Text('more infor', style: TextStyle(color: Colors.grey.shade500),),
                                    Text("more",
                                        style: TextStyle(
                                            color: Colors.grey.shade500)),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                ),
                                onTap: () => {
                                  if (_device != null)
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeviceInfo(device: _device!)))
                                },
                              )
                            ]),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "S/N: $_robotSN",
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: _isConnectA2D ? kGreen : kOrange,
                                      size: 12.0,
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    Text(
                                      _isConnectA2D ? "Connected" : "Disconnect",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: _isConnectA2D ? kGreen : kOrange),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () => _requestConnectA2D(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kDarkBlue,
                              ),
                              child: const Text(
                                "connect",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: maxWidth - 20.0,
                  width: maxWidth - 20.0,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: kDarkBlue, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.0),
                    child: Image.network(map2dUrl, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/icon_404_not_found.png',
                        fit: BoxFit.contain,
                      );
                      // return const Center(
                      //   child: Text(
                      //     "Loading image map ...",
                      //     style: TextStyle(fontSize: 24.0),
                      //   ),
                      // );
                    }),
                  ),
                ),
                const SizedBox(height: 10.0),

                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: 100.0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: _isConnectA2D ? () {} : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kDarkBlue,
                                fixedSize: const Size(50, 50),
                                shape: const CircleBorder(),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _isConnectA2D ? () {} : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kDarkBlue,
                                fixedSize: const Size(50, 50),
                                shape: const CircleBorder(),
                              ),
                              child: const Icon(
                                Icons.pause_rounded,
                                color: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _isConnectA2D ? () {} : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kDarkBlue,
                                fixedSize: const Size(50, 50),
                                shape: const CircleBorder(),
                              ),
                              child: const Icon(
                                Icons.stop_rounded,
                                color: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _isConnectA2D ? () {} : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kDarkBlue,
                                fixedSize: const Size(50, 50),
                                shape: const CircleBorder(),
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _isConnectA2D ? () {} : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kDarkBlue,
                                fixedSize: const Size(50, 50),
                                shape: const CircleBorder(),
                              ),
                              child: const Icon(
                                Icons.remove_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
