import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gas_detek/common/alert_helper.dart';
import 'package:gas_detek/model/device_model.dart';
import 'package:gas_detek/model/room_model.dart';
import 'package:gas_detek/screens/device_info_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _fetchDataRoom();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    String map2dUrl = "$domain/images/${_room.map2dUrl}";
    // String map2dUrl = 'https://raspberrypi.vn/wp-content/uploads/2016/10/raspberry_pi_3.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _room.roomName,
          textAlign: TextAlign.center,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
          IconButton(
            onPressed: () { },
            icon: const Icon(
              Icons.check_rounded,
              size: 36,
              color: Colors.white,
            ),
          ),
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
                        Text('Save Map 2D'),
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
                    _saveImage(map2dUrl);
                    break;
                  case 1:
                    print("Delete Room selected.");
                    break;
                }
              }
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                  Text("more",
                                      style: TextStyle(
                                          color: Colors.grey.shade500)),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color: Colors.grey.shade400,
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
              const SizedBox(height: 30.0),
              // TODO: create main UI below here
              Container(
                height: maxWidth,
                width: maxWidth,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
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
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(map2dUrl, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                    // return Image.asset('assets/images/icon_404_not_found.png');
                    return const Text(
                      "Loading image map ...",
                      style: TextStyle(fontSize: 24.0),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 30.0),

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
                            onPressed: () {},
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
                            onPressed: () {},
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
                            onPressed: () {},
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
                            onPressed: () {},
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
                            onPressed: () {},
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
    );
  }
}
