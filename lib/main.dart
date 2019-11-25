import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:BlueRa/screens/Home.dart';

void main() {
  runApp(new BlueRa());
}

class BlueRa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "BlueRa",
      home: new HomeScreen(),
    );
  }
}
