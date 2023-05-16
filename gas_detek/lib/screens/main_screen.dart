import 'package:gas_detek/widgets/room_grid_widget.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../widgets/side_menu_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Gas Detection",
        textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.grey, size: 36),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.notifications,
          //     color: Colors.grey,
          //   ),
          // ),
          IconButton(
            onPressed: () {
              print("add scan room");
            },
            icon: const Icon(
              Icons.add,
              color: Colors.grey,
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
          //   child: const CircleAvatar(
          //     backgroundImage: NetworkImage(
          //         "https://images.unsplash.com/photo-1500522144261-ea64433bbe27?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTh8fHdvbWVufGVufDB8MHwwfHw%3D&auto=format&fit=crop&w=500&q=60"),
          //   ),
          // )
        ],
      ),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                text: const TextSpan(
                  text: "Hello ",
                  style: TextStyle(color: kDarkBlue, fontSize: 20),
                  children: [
                    TextSpan(
                      text: "Nguyen Hung",
                      style: TextStyle(
                          color: kDarkBlue, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
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
              const RoomGrid(),
              // const SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
