import 'package:flutter/material.dart';
import 'package:gas_detek/model/room_model.dart';

class RoomWidget extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const RoomWidget(
      {Key? key,
        required this.room,
        required this.onTap,
        required this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    room.lessons,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Text(room.text,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400))
              ],
            ),
          ),
        ),
      ),
    );
  }
}