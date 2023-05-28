import 'package:gas_detek/data/data.dart';
import 'package:flutter/material.dart';

class RoomGrid extends StatelessWidget {
  const RoomGrid({Key? key}) : super(key: key);

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
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage(listRoom[index].backImage), fit: BoxFit.fill),
            // ),
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
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        listRoom[index].roomStatus,
                        style: const TextStyle(color: Colors.white),
                      ),
                      // CircularPercentIndicator(
                      //   radius: 30,
                      //   lineWidth: 8,
                      //   animation: true,
                      //   animationDuration: 1500,
                      //   circularStrokeCap: CircularStrokeCap.round,
                      //   percent: course[index].percent / 100,
                      //   progressColor: Colors.white,
                      //   center: Text(
                      //     "${course[index].percent}%",
                      //     style: const TextStyle(color: Colors.white),
                      //   ),
                      // )
                    ],
                  ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Image.asset(
                  //       course[index].imageUrl,
                  //       height: 110,
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
          );
        });
  }
}
