import 'package:flutter/material.dart';
import 'package:gas_detek/model/device_model.dart';
import 'package:gas_detek/model/room_model.dart';
import 'package:gas_detek/services/device_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class RoomDetail extends StatefulWidget {
  final Room room;
  const RoomDetail({Key? key, required this.room}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RoomDetailState();
  }
}

class _RoomDetailState extends State<RoomDetail> {
  late Room _room;
  late Device? _device;
  String _robotName = "";
  String _robotSN = "";

  Future<void> _fetchDataRoom() async {
    // TODO: Call api get device of user
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

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _fetchDataRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _room.roomName,
          textAlign: TextAlign.center,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
                        Text('Save Image'),
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
                            'Delete Room',
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
                    print("Save Image selected.");
                    break;
                  case 1:
                    print("Delete Room selected.");
                    break;
                }
              }),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // create box information about robot
              Container(
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
                  padding: const EdgeInsets.fromLTRB(15, 15, 5, 15),
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
                                  Text("more info", style: TextStyle(color: Colors.grey.shade500)),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color: Colors.grey.shade400,
                                  )
                                ],
                              ),
                              onTap: () => {print("tap on more info ${_device?.toJson()}") },
                            )
                          ]),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: kGreen,
                            size: 12.0,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "Online",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 30.0),
              // TODO: create main UI below here
            ],
          )),
    );
  }
}
