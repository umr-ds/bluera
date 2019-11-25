import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:BlueRa/data/MockData.dart';

class UserSettingsScreen extends StatelessWidget {
  final TextEditingController _userNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("User Settings"),
        backgroundColor: Color(0xFF0A3D91),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Padding(
          child: new Column(
            children: <Widget>[
              new TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: localUser.name
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new RaisedButton(
                      onPressed: () {
                        localUser.name = _userNameController.text;
                        Navigator.pop(context);
                      },
                    child: new Text("OK"),
                  ))
                ],
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
        )
      );
  }
}
