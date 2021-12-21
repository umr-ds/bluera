import 'package:flutter/material.dart';
import 'package:bluera/connectors/RF95.dart';

class LoraSettingsScreen extends StatefulWidget {
  State createState() => new LoraSettingsScreenState();
}

class LoraSettingsScreenState extends State<LoraSettingsScreen> {
  void _setMode(BuildContext context, int mode) async {
    await rf95.setMode(mode);
    await setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("LoRa Settings"),
          backgroundColor: Color(0xFF0A3D91),
        ),
        body: ListView(children: <Widget>[
          RadioListTile<int>(
            title: Text("0 - Medium Range"),
            subtitle: Text("Bw: 125 kHz, Cr: 4/5, Sf: 128chips/symbol"),
            value: 0,
            groupValue: rf95.mode,
            onChanged: (value) => _setMode(context, value),
          ),
          Divider(),
          RadioListTile<int>(
            title: Text("1 - Fast+Short Range"),
            subtitle: Text("Bw: 500 kHz, Cr: 4/5, Sf: 128chips/symbol"),
            value: 1,
            groupValue: rf95.mode,
            onChanged: (value) => _setMode(context, value),
          ),
          Divider(),
          RadioListTile<int>(
            title: Text("2 - Slow+Long Range"),
            subtitle: Text("Bw: 31.25 kHz, Cr: 4/8, Sf: 512chips/symbol"),
            value: 2,
            groupValue: rf95.mode,
            onChanged: (value) => _setMode(context, value),
          ),
          Divider(),
          RadioListTile<int>(
            title: Text("3 - Slow+Long Range"),
            subtitle: Text("Bw: 125 kHz, Cr: 4/8, Sf: 4096chips/symbol"),
            value: 3,
            groupValue: rf95.mode,
            onChanged: (value) => _setMode(context, value),
          ),
          Divider(),
          RadioListTile<int>(
            title: Text("4 - Slow+Long Range"),
            subtitle: Text("Bw: 125 kHz, Cr: 4/5, Sf: 2048chips/symbol"),
            value: 4,
            groupValue: rf95.mode,
            onChanged: (value) => _setMode(context, value),
          ),
        ]));
  }
}
