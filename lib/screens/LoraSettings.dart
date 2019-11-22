import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoraSettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("LoRa Settings"),
        backgroundColor: Color(0xFF0A3D91),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Text("Here will be the LoRa settings.")
      );
  }
}
