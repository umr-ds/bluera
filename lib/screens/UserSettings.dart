import 'package:flutter/material.dart';
import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/connectors/Username.dart';
import 'package:BlueRa/screens/Home.dart';

class UserSettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserSettingsScreenState();

}

class UserSettingsScreenState extends State<UserSettingsScreen> {
  final TextEditingController _userNameController = new TextEditingController();
  bool _valid = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Choose a User Name"),
        backgroundColor: Color(0xFF0A3D91)
      ),
      body: new Padding(
          child: new Column(
            children: <Widget>[
              new TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: localUser == null ? "Enter Username" : localUser,
                  errorText: _valid ? 'Please enter Username' : null,
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new RaisedButton(
                      onPressed: () {
                        setState(() {
                          _userNameController.text.isEmpty ? _valid = false : _valid = true;
                        });
                        if (_valid) {
                          localUser = _userNameController.text;
                          UsernameConnector.write(localUser);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            )
                          );
                        }
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
