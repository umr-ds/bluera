import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/MockData.dart';
import 'package:BlueRa/screens/AddChannel.dart';
import 'package:BlueRa/screens/UserSettings.dart';
import 'package:BlueRa/screens/BluetoothSettings.dart';
import 'package:BlueRa/screens/LoraSettings.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("BlueRa"),
        backgroundColor: Color(0xFF0A3D91),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddChannelDialog(),
                ),
              );
            },
          ),
          PopupMenuButton<Icon>(
            icon: Icon(Icons.more_horiz),
            onSelected: (Icon result) => moreButtonAction(result, context),
            itemBuilder: (BuildContext context) {
              return MoreButtonConstants.moreButtonItems.map((Icon choice) {
                return PopupMenuItem<Icon>(
                  value: choice,
                  child: choice,
                );
              }).toList();
            },
          ),
        ],
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) =>
            ChannelOverviewItem(channels[index], context),
        itemCount: channels.length,
      ),
    );
  }
}


class MoreButtonConstants {
  static Icon userSettings = new Icon(Icons.perm_identity);
  static Icon bluetoothSettings = new Icon(Icons.settings_bluetooth);
  static Icon loraSettings = new Icon(Icons.settings_input_antenna);

  static final List<Icon> moreButtonItems = [
    userSettings,
    bluetoothSettings,
    loraSettings
  ];
}

void moreButtonAction(Icon choice, BuildContext context) {
  if (choice == MoreButtonConstants.userSettings) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSettingsScreen(),
      ),
    );
  } else if (choice == MoreButtonConstants.bluetoothSettings) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BluetoothSettingsScreen(),
      ),
    );
  } else if (choice == MoreButtonConstants.loraSettings) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoraSettingsScreen(),
      ),
    );
  }
}
