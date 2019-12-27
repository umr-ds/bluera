import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:BlueRa/connectors/RF95.dart';

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

class BluetoothOnScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BluetoothOffScreenState();
}

class BluetoothOffScreenState extends State<BluetoothOnScreen> {
  bool isConnected = false;
  bool searching = false;

  static void reconnect() {
    FlutterBlue.instance.connectedDevices.then((devices) {
      for (BluetoothDevice device in devices) {
        device.discoverServices().then((services) {
          services.forEach((service) {
            if (service.uuid == serviceUUID) {
              rf95 = RF95(device);
              for (BluetoothCharacteristic characteristic
                  in service.characteristics) {
                if (characteristic.uuid == writeCharacteristicUUID) {
                  rf95.writeCharacteristic = characteristic;
                }

                if (characteristic.uuid == readCharacteristicUUID) {
                  rf95.readCharacteristic = characteristic;
                }
              }
            }
          });
        });
      }
    });
  }

  List<Widget> _defaultHint() {
    searching = true;

    reconnect();

    searching = false;
    setState(() => isConnected = rf95 == null);
    return isConnected
        ? [ListTile(title: Text("Not Connected."))]
        : _connectedDevice();
  }

  List<Widget> _connectedDevice() {
    return [
      ListTile(
          title: Text(rf95.dev.name),
          subtitle: Text(rf95.dev.id.toString()),
          trailing: FlatButton(
              child: Text("Disconnect"),
              onPressed: () async {
                await rf95.disconnect();
                rf95 = null;
                setState(() => isConnected = false);
              }))
    ];
  }

  Widget _connectedDevicesTile() {
    setState(() => isConnected = rf95 == null ? false : true);
    return Column(children: rf95 == null ? _defaultHint() : _connectedDevice());
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Stack(children: <Widget>[
      ListView(children: <Widget>[
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
            trailing: (!isConnected && searching)
                ? const CircularProgressIndicator()
                : Text("")),
        _connectedDevicesTile(),
        Divider(),
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
      ])
    ]));
  }
}

class BluetoothScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan'),
          backgroundColor: Color(0xFF0A3D91),
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Column(
                children: <Widget>[
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data
                          .map(
                            (r) => ScanResultTile(r),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class ScanResultTile extends StatelessWidget {
  ScanResultTile(this.result);

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

  void _connect(BluetoothDevice device) async {
    rf95 = RF95(device);

    List<BluetoothService> services = await device.discoverServices();

    services.forEach((service) {
      if (service.uuid == serviceUUID) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid == writeCharacteristicUUID) {
            rf95.writeCharacteristic = characteristic;
          }

          if (characteristic.uuid == readCharacteristicUUID) {
            rf95.readCharacteristic = characteristic;
          }
        }
      }
    });
  }

  void _connectAndReturn(BluetoothDevice device, BuildContext context) async {
    await device.connect();
    _connect(device);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context),
      leading: Text(result.rssi.toString() + "dB"),
      trailing: FlatButton(
        child: Text('Connect'),
        onPressed: () => result.advertisementData.connectable
            ? _connectAndReturn(result.device, context)
            : null,
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
