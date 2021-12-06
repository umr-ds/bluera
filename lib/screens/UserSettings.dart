import 'package:flutter/material.dart';
import 'package:bluera/data/Globals.dart';
import 'package:bluera/connectors/Username.dart';
import 'package:bluera/screens/Home.dart';

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
            backgroundColor: Color(0xFF0A3D91)),
        body: new Padding(
          child: new Column(
            children: <Widget>[
              new TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: localUser == null ? "Enter Username" : localUser,
                  errorText: _valid
                      ? "Username must not be empty and must not contain '|'"
                      : null,
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                      child: new ElevatedButton(
                    onPressed: () {
                      setState(() {
                        bool notEmpty = _userNameController.text.isNotEmpty;
                        bool validChars =
                            !(_userNameController.text.contains("|"));
                        (notEmpty && validChars)
                            ? _valid = true
                            : _valid = false;
                      });
                      if (_valid) {
                        localUser = _userNameController.text;
                        UsernameConnector.write(localUser);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ));
                      }
                    },
                    child: new Text("OK"),
                  ))
                ],
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
        ));
  }
}
