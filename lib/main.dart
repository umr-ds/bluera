import 'package:flutter/material.dart';

import 'package:BlueRa/screens/Home.dart';
import 'package:BlueRa/connectors/Username.dart';
import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/screens/BluetoothSettings.dart';
import 'package:BlueRa/connectors/Location.dart';
import 'package:BlueRa/main.adapter.g.m8.dart';

void main() {
  databaseProvider = DatabaseProvider(DatabaseAdapter());
  runApp(new BlueRa());
}

class BlueRa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserLocationStream().locationService();

    BluetoothOffScreenState.reconnect();

    UsernameConnector.read();

    return new MaterialApp(
      title: "BlueRa",
      home: HomeScreen(),
    );
  }
}
