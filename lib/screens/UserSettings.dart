import 'package:BlueRa/data/Settings.g.m8.dart';
import 'package:flutter/material.dart';

import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/screens/Home.dart';

class UserSettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserSettingsScreenState();
}

class UserSettingsScreenState extends State<UserSettingsScreen> {
  final TextEditingController _userNameController = new TextEditingController();
  bool _valid = false;

  @override
  void initState() {
    _userNameController.text = settings == null ? "" : settings.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: Text("User Settings"), backgroundColor: Color(0xFF0A3D91)),
      body: new Padding(
        child: new Column(
          children: <Widget>[
            new TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: "Username",
                errorText: _valid
                    ? "Username must not be empty and must not contain '|'"
                    : null,
              ),
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                    child: new RaisedButton(
                  onPressed: () {
                    setState(
                      () {
                        _valid = _userNameController.text.isNotEmpty &&
                            !(_userNameController.text.contains("|"));
                      },
                    );
                    if (_valid) {
                      if (settings == null) {
                        settings =
                            new SettingsProxy(user: _userNameController.text);
                        databaseProvider.saveSettings(settings);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      } else {
                        settings.user = _userNameController.text;
                        databaseProvider.updateSettings(settings);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: new Text("OK"),
                ))
              ],
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
      ),
    );
  }
}
