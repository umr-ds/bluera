import 'package:BlueRa/screens/UserSettings.dart';
import 'package:flutter/material.dart';

import 'package:BlueRa/screens/Home.dart';
import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/screens/BluetoothSettings.dart';
import 'package:BlueRa/connectors/Location.dart';
import 'package:BlueRa/data/Settings.g.m8.dart';
import 'package:BlueRa/main.adapter.g.m8.dart';

// void initSettings() async {
//   List<SettingsProxy> savedSettings =
//       await databaseProvider.getSettingsProxiesAll();
//   settings = savedSettings.first;
// }

void main() {
  databaseProvider = DatabaseProvider(DatabaseAdapter());
  runApp(new BlueRa());
}

class BlueRa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserLocationStream().locationService();

    BluetoothOffScreenState.reconnect();

    return new MaterialApp(
      title: "BlueRa",
      home: FutureBuilder(
        future: databaseProvider.getSettingsProxiesAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SettingsProxy> settingsList = snapshot.data;
            if (snapshot.data.length == 0) {
              return UserSettingsScreen();
            } else {
              settings = snapshot.data.first;
              return HomeScreen();
            }
          }
          return UserSettingsScreen();
        },
      ),
    );
  }
}
