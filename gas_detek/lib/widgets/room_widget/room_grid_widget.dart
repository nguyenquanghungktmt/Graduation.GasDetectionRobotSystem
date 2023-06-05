// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gas_detek/common/alert_helper.dart';
import 'package:gas_detek/model/room_model.dart';
import 'package:gas_detek/screens/room_detail_screen.dart';
import 'package:gas_detek/widgets/room_widget/room_cell_widget.dart';

class RoomGrid extends StatelessWidget {
  late List<Room> listRoom;
  late int totalRoom;
  final void Function(Room) deleteRoom;

  RoomGrid(
      {Key? key,
      required this.listRoom,
      required this.totalRoom,
      required this.deleteRoom})
      : super(key: key);

  Future<void> _deleteRoomActionHandler(BuildContext context, Room room) async {
    bool? isYes = await Alert.dialogConfirmation(
      context,
      'Delete?',
      'Are you sure delete room ${room.roomName} ?',
    );
    if (!(isYes ?? false)) return;
    deleteRoom(room);
  }

  @override
  Widget build(BuildContext context) {
    if (totalRoom == 0) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/icon_not_found.png",
              width: 250.0,
              height: 250.0,
            ),
            const Text(
              'You have no rooms yet',
              style: TextStyle(fontSize: 20.0),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ]);
    }
    return GridView.builder(
        itemCount: totalRoom,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 16 / 7, crossAxisCount: 1, mainAxisSpacing: 30),
        itemBuilder: (context, index) => RoomCellWidget(
              room: listRoom[index],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RoomDetail(room: listRoom[index])));
              },
              onLongPress: () =>
                  _deleteRoomActionHandler(context, listRoom[index]),
            ));
  }
}
