import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:BlueRa/settings/Bluetooth.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothSettingsScreen extends StatefulWidget {
  State createState() => new BluetoothSettingsScreenState();
}

class BluetoothSettingsScreenState extends State<BluetoothSettingsScreen> {
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Bluetooth Settings"),
        backgroundColor: Color(0xFF0A3D91),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return BluetoothOnScreen();
            }
            return BluetoothOffScreen();
          }),
    );
  }
}

class BluetoothOnScreen extends StatelessWidget {
  Text getConnectedDevice() {
    StreamBuilder<List<BluetoothDevice>>(
        stream: Stream.periodic(Duration(seconds: 2))
            .asyncMap((_) => FlutterBlue.instance.connectedDevices),
        initialData: [],
        builder: (c, snapshot) {
          return Text(snapshot.data[0].name,
              style: TextStyle(color: Colors.white));
        });

    return Text("Not connected.", style: TextStyle(color: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
    child: new Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              color: Colors.lightGreen,
              child: ListTile(
                title: Text("Bluetooth is Enabled",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              title: Text("Conected Devices:"),
            ),
            StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.periodic(Duration(seconds: 2))
                  .asyncMap((_) => FlutterBlue.instance.connectedDevices),
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data
                    .map((d) => ListTile(
                          title: StreamBuilder<BluetoothDeviceState>(
                            stream: d.state,
                            initialData: BluetoothDeviceState.disconnected,
                            builder: (c, snapshot) {
                              return Text(d.name);
                            },
                          ),
                          trailing: FlatButton(
                            child: Text('Disconnect'),
                            onPressed: () => d.disconnect(),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Settings"),
            ),
            ListTile(
              title: Text("Scan for Devices"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BluetoothScanScreen(),
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios),
            ),
        ])]));
  }
}

class BluetoothScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan'),
        backgroundColor: Color(0xFF0A3D91),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result}) : super(key: key);

  final ScanResult result;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  void _connectAndReturn(BluetoothDevice device, BuildContext context) {
    device.connect();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context),
      leading: Text(result.rssi.toString() + "dB"),
      trailing: FlatButton(
        child: Text('Connect'),
        onPressed: () => result.advertisementData.connectable ? _connectAndReturn(result.device, context) : null,
      ),
    );
  }
}


class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A3D91),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is disabled!',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
