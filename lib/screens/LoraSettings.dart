import 'package:flutter/material.dart';
import 'package:bluera/connectors/RF95.dart';

class LoraSettingsScreen extends StatefulWidget {
  State createState() => new LoraSettingsScreenState();
}

// https://www.rfwireless-world.com/Tutorials/LoRa-channels-list.html
List<DropdownMenuItem<double>> _freqs = [
  // 433
  DropdownMenuItem(
    child: Text("433 Channel 1: 433.175 MHz"),
    value: 433.175,
  ),
  DropdownMenuItem(
    child: Text("433 Channel 2: 433.375 MHz"),
    value: 433.375,
  ),
  DropdownMenuItem(
    child: Text("433 Channel 3: 433.575 MHz"),
    value: 433.575,
  ),
  // 868
  DropdownMenuItem(
    child: Text("868 Channel 10: 865.20 MHz"),
    value: 865.20,
  ),
  DropdownMenuItem(
    child: Text("868 Channel 11: 865.50 MHz"),
    value: 865.50,
  ),
  DropdownMenuItem(
    child: Text("868 Channel 12: 865.80 MHz"),
    value: 865.80,
  ),
  DropdownMenuItem(
    child: Text("868 Channel 13: 866.10 MHz"),
    value: 866.10,
  ),
  DropdownMenuItem(
    child: Text("868 Channel 14: 866.40 MHz"),
    value: 866.40,
  ),
  DropdownMenuItem(
    child: Text("868 Channel 15: 866.70 MHz"),
    value: 866.70,
  ),
  DropdownMenuItem(
    child: Text("868 Channel 16: 867.00 MHz"),
    value: 867.00,
  ),
  DropdownMenuItem(
    child: Text("868 Channel 17: 868.00 MHz"),
    value: 868.00,
  ),
  // 900 MHz Band
  DropdownMenuItem(
    child: Text("900 Channel 00: 903.08 MHz"),
    value: 903.08,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 01: 905.24 MHz"),
    value: 905.24,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 02: 907.40 MHz"),
    value: 907.40,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 03: 909.56 MHz"),
    value: 909.56,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 04: 911.72 MHz"),
    value: 911.72,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 05: 913.88 MHz"),
    value: 913.88,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 06: 916.04 MHz"),
    value: 916.04,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 07: 918.20 MHz"),
    value: 918.20,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 08: 920.36 MHz"),
    value: 920.36,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 09: 922.52 MHz"),
    value: 922.52,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 10: 924.68 MHz"),
    value: 924.68,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 11: 926.84 MHz"),
    value: 926.84,
  ),
  DropdownMenuItem(
    child: Text("900 Channel 12: 915.00 MHz"),
    value: 915.00,
  ),
];

class LoraSettingsScreenState extends State<LoraSettingsScreen> {
  void _setMode(BuildContext context, int mode) async {
    await rf95.setMode(mode);
    await setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (rf95?.dev == null) {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text("LoRa Settings"),
            backgroundColor: Color(0xFF0A3D91),
          ),
          body: Scaffold(
            backgroundColor: Color(0xFF0A3D91),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.error,
                    size: 200.0,
                    color: Colors.white54,
                  ),
                  Text(
                    "Not connected to rf95modem devive.",
                    style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ));
    }

    List<DropdownMenuItem<double>> freqs = List.from(_freqs);

    if (!freqs.any((f) => f.value == rf95.freq)) {
      freqs.insert(
        0,
        DropdownMenuItem(
          child: Text("Read from device: ${rf95.freq} MHz"),
          value: rf95.freq,
        ),
      );
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("LoRa Settings"),
          backgroundColor: Color(0xFF0A3D91),
        ),
        body: ListView(children: <Widget>[
          ListTile(
            title: Text("Frequency & Channel"),
            trailing: DropdownButton(
              value: rf95.freq,
              items: freqs,
              onChanged: (value) async {
                await rf95.setFreq(value);
                await setState(() {});
              },
            ),
          ),
          Divider(),
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
