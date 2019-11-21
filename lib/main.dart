import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Bluera/screens/Chat.dart';

void main() {
  runApp(new FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Bluera",
      home: new ChatScreen(),
    );
  }
}
