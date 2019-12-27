import 'package:flutter/material.dart';

import 'package:BlueRa/connectors/RF95.dart';

class LoraSettingsScreen extends StatelessWidget {
  void _setAndReturn(BuildContext context, String mode) {
    rf95.setMode(mode);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("LoRa Settings"),
          backgroundColor: Color(0xFF0A3D91),
        ),
        body: ListView(children: <Widget>[
          ListTile(
              title: Text("Medium Range"),
              subtitle: Text("Bw: 125 kHz, Cr: 4/5, Sf: 128chips/symbol"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _setAndReturn(context, "0");
              }),
          Divider(),
          ListTile(
              title: Text("Fast+Short Range"),
              subtitle: Text("Bw: 500 kHz, Cr: 4/5, Sf: 128chips/symbol"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _setAndReturn(context, "1");
              }),
          Divider(),
          ListTile(
              title: Text("Slow+Long Range"),
              subtitle: Text("Bw: 31.25 kHz, Cr: 4/8, Sf: 512chips/symbol"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _setAndReturn(context, "2");
              }),
          Divider(),
          ListTile(
              title: Text("Slow+Long Range"),
              subtitle: Text("Bw: 125 kHz, Cr: 4/8, Sf: 4096chips/symbol"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _setAndReturn(context, "3");
              })
        ]));
  }
}
