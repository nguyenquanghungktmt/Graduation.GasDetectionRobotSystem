// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gas_detek/model/room_model.dart';

class RoomGrid extends StatelessWidget {
  late List<Room> listRoom;
  late int totalRoom;
  RoomGrid({Key? key, required this.listRoom, required this.totalRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: listRoom.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 16 / 6, crossAxisCount: 1, mainAxisSpacing: 20),
        itemBuilder: (context, index) {
          return Container(
            width: 50,
            decoration: BoxDecoration(
              color: Colors.amber[50],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        listRoom[index].roomName,
                        style: const TextStyle(color: Colors.black),
                      ),
                      Text(
                        listRoom[index].roomStatus,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
