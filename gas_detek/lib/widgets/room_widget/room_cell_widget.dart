// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gas_detek/model/room_model.dart';

class RoomCellWidget extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const RoomCellWidget(
      {Key? key,
      required this.room,
      required this.onTap,
      required this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorConcept = room.isGasDetect == 1 ? Colors.red : Colors.green;
    final colorGasIcon = room.isGasDetect == 1 ? Colors.orange : Colors.blue;
    final textGasStatus =
        room.isGasDetect == 1 ? "Warning! Gas Leak Detection" : "No Gas Leak";
    // return InkWell(
    //   child: Container(width: 100, height: 100),
    //   onTap: () {
    //     print("Wow! Ripple");
    //   },
    // );
    
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: colorConcept.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(room.roomName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 24.0,
                    color: colorGasIcon.shade800,
                  ),
                  SizedBox(width: 10),
                  Text(textGasStatus),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    size: 24.0,
                    color: colorConcept.shade600,
                  ),
                  SizedBox(width: 10),
                  Text(room.roomStatus),
                ],
              ),
            ],
          )),
      ));
    
  }
}
