// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gas_detek/model/room_model.dart';
import 'package:gas_detek/widgets/room_widget/room_cell_widget.dart';

class RoomGrid extends StatelessWidget {
  late List<Room> listRoom;
  late int totalRoom;
  RoomGrid({Key? key, required this.listRoom, required this.totalRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          print("onTap");
        },
        onLongPress: () {
          print("onLongPress");
        },
      ));
  }
}
