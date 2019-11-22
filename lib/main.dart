import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Bluera/screens/Home.dart';

void main() {
  runApp(new Bluera());
}

class Bluera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Bluera",
      home: new HomeScreen(),
    );
  }
}
