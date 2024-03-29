import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bluera/screens/Home.dart';
import 'package:bluera/connectors/Database.dart';
import 'package:bluera/connectors/Location.dart';
import 'package:bluera/connectors/Username.dart';
import 'package:bluera/data/Channel.dart';
import 'package:bluera/data/Message.dart';
import 'package:bluera/data/Globals.dart';
import 'package:bluera/screens/BluetoothSettings.dart';
import 'package:bluera/screens/UserSettings.dart';

void main() {
  runApp(new BlueRa());
}

class BlueRa extends StatelessWidget {
  final DBConnector dbHelper = DBConnector.instance;

  Future<bool> initAppState() async {
    print("Starting Location Stream");
    await UserLocation().initLocationService();
    print("Reconnecting to Bluetooth Device");
    await BluetoothScreenState.reconnect();
    print("Reading username");
    await UsernameConnector.read();

    print("Initializing chats from database");
    List<Map<String, dynamic>> rows = await dbHelper.queryAllRows();
    for (Map<String, dynamic> row in rows) {
      String channelName = row[DBConnector.columnName];
      bool attending = row[DBConnector.columnAttending].toLowerCase() == "true";
      String messagesJson = row[DBConnector.columnMessages];
      Iterable jsonObjects = json.decode(messagesJson);
      List<Message> messages =
          jsonObjects.map((item) => Message.fromJson(item)).toList();
      ValueNotifier<Channel> _chn =
          ValueNotifier<Channel>(Channel(channelName, attending, messages));
      if (Channel.getChannel(_chn.value.name) != null) {
        continue;
      }
      channels.value.add(_chn);
      channels.notifyListeners();
    }

    print("Finished initialization of app state");

    return true;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: initAppState(),
        builder: (context, appStateReady) {
          if (appStateReady.hasData) {
            print("Initialization finished, building app");
            return new MaterialApp(
              title: "BlueRa",
              home: localUser == null ? UserSettingsScreen() : HomeScreen(),
            );
          } else {
            print("Init not finished, showing progress incicator");
            return Center(child: CircularProgressIndicator());
          }
        },
      );
}
