import 'package:flutter/material.dart';

import 'package:BlueRa/screens/Home.dart';
import 'package:BlueRa/connectors/Username.dart';
import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/screens/BluetoothSettings.dart';
import 'package:BlueRa/screens/UserSettings.dart';
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

    // dbHelper.queryAllRows().then((rows) {
    //   for (Map<String, dynamic> row in rows) {
    //     String channelName = row[DBConnector.columnName];
    //     bool attending =
    //         row[DBConnector.columnAttending].toLowerCase() == "true";
    //     String messagesJson = row[DBConnector.columnMessages];
    //     Iterable jsonObjects = json.decode(messagesJson);
    //     List<Message> messages =
    //         jsonObjects.map((item) => Message.fromJson(item)).toList();
    //     ValueNotifier<Channel> _chn =
    //         ValueNotifier<Channel>(Channel(channelName, attending, messages));
    //     if (Channel.getChannel(_chn.value.name) != null) {
    //       continue;
    //     }
    //     channels.value.add(_chn);
    //     channels.notifyListeners();
    //   }
    // });
    return new MaterialApp(
      title: "BlueRa",
      home: HomeScreen(),
    );
  }
}
