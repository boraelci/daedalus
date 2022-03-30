import 'package:flutter/material.dart';
// TODO: Improve or delete. This page currently displays map and search pages (older version) together.
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context)
        .size
        .width; // Using this line I got the device screen width
    return Scaffold(
      body: Column(children: [
        Expanded(
          flex: 1,
          child: Container(
              width: width,
              child: const Center(child: Text("Profile page coming soon!"))
          ),
        ),
      ]),
    );
  }
}
