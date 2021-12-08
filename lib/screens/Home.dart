import 'package:flutter/material.dart';
import 'package:bluera/data/Channel.dart';
import 'package:bluera/data/Globals.dart';
import 'package:bluera/screens/AddChannel.dart';
import 'package:bluera/screens/UserSettings.dart';
import 'package:bluera/screens/BluetoothSettings.dart';
import 'package:bluera/screens/LoraSettings.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("BlueRa"),
          backgroundColor: Color(0xFF0A3D91),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddChannelDialog(),
                  ),
                );
              },
            ),
            PopupMenuButton<MenuButtonItem>(
              icon: Icon(Icons.more_horiz),
              onSelected: (MenuButtonItem result) => moreButtonAction(result, context),
              itemBuilder: (BuildContext context) {
                return MenuButtons.moreButtonItems.map((MenuButtonItem choice) {
                  return PopupMenuItem<MenuButtonItem>(
                    value: choice,
                    child: new Row(
                      children: <Widget>[
                        new Flexible(child: choice.buttonIcon),
                        new Container(
                          margin: new EdgeInsets.only(left: 20.0),
                          child: Text(choice.buttonDescription),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: channels,
          builder: (BuildContext context, List<ValueNotifier<Channel>> channels, Widget child) {
            var localChannels = channels.where((channel) => channel.value.attending == true).toList();
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ChannelOverviewItem(localChannels[index].value, context);
              },
              itemCount: localChannels.length,
            );
          },
        ));
  }
}

class MenuButtonItem {
  MenuButtonItem(this.buttonIcon, this.buttonDescription);

  final Icon buttonIcon;
  final String buttonDescription;
}

class MenuButtons {
  static MenuButtonItem userSettings =
      new MenuButtonItem(new Icon(Icons.perm_identity, color: Color(0xFF0A3D91)), "User Settings");
  static MenuButtonItem bluetoothSettings =
      new MenuButtonItem(new Icon(Icons.settings_bluetooth, color: Color(0xFF0A3D91)), "Bluetooth Settings");
  static MenuButtonItem loraSettings =
      new MenuButtonItem(new Icon(Icons.settings_input_antenna, color: Color(0xFF0A3D91)), "LoRa Settings");

  static final List<MenuButtonItem> moreButtonItems = [userSettings, bluetoothSettings, loraSettings];
}

void moreButtonAction(MenuButtonItem choice, BuildContext context) {
  if (choice == MenuButtons.userSettings) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSettingsScreen(),
      ),
    );
  } else if (choice == MenuButtons.bluetoothSettings) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BluetoothSettingsScreen(),
      ),
    );
  } else if (choice == MenuButtons.loraSettings) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoraSettingsScreen(),
      ),
    );
  }
}
