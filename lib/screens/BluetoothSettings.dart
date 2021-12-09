import 'dart:async';

import 'package:bluera/connectors/Location.dart';
import 'package:flutter/material.dart';
import 'package:bluera/connectors/RF95.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:location/location.dart';

class BluetoothSettingsScreen extends StatefulWidget {
  State createState() => new BluetoothSettingsScreenState();
}

class BluetoothSettingsScreenState extends State<BluetoothSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // principal layout
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Bluetooth Settings"),
        backgroundColor: Color(0xFF0A3D91),
      ),
      body: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, bluetoothState) {
            // Bluetooth state not yet known
            if (!bluetoothState.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            // Bluetooth is not enabled or permissions are missing.
            if (bluetoothState.data != BluetoothState.on) {
              return BluetoothSettingsErrorScreen(
                errorText: "Bluetooth not available: ${bluetoothState.data.toString()}.",
                iconData: Icons.bluetooth_disabled,
              );
            }

            return FutureBuilder(
              future: UserLocation.location.serviceEnabled(),
              builder: (context, locationServiceEnabled) {
                // Location service status is not yet known
                if (!locationServiceEnabled.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // Location services are disabled
                if (!locationServiceEnabled.data) {
                  return BluetoothSettingsErrorScreen(
                    errorText: "Location Services are disabled.",
                    iconData: Icons.location_off,
                  );
                }

                // location services are enabled -> check permissions
                return FutureBuilder(
                    future: UserLocation.location.hasPermission(),
                    builder: (context, locationServicePermission) {
                      // Permissions are not yet known
                      if (!locationServicePermission.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      switch (locationServicePermission.data) {
                        case PermissionStatus.granted:
                        case PermissionStatus.grantedLimited:
                          return BluetoothOnScreen();

                        default:
                          return BluetoothSettingsErrorScreen(
                            errorText: "Location Services permissions missing: ${locationServicePermission.data}",
                            iconData: Icons.location_off,
                          );
                      }
                    });
              },
            );
          }),
    );
  }
}

class BluetoothOnScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BluetoothScreenState();
}

class BluetoothScreenState extends State<BluetoothOnScreen> {
  static void reconnect() {
    FlutterBlue.instance.connectedDevices.then((devices) {
      for (BluetoothDevice device in devices) {
        device.discoverServices().then((services) {
          services.forEach((service) {
            if (service.uuid == serviceUUID) {
              rf95 = RF95(device);
              for (BluetoothCharacteristic characteristic in service.characteristics) {
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

  Widget _defaultHint() {
    return ListTile(title: Text("Not connected to a device."));
  }

  Widget _connectedDevice() {
    return ListTile(
        title: Text(rf95.dev.name),
        subtitle: Text(rf95.dev.id.toString()),
        trailing: TextButton(
            child: Text("Disconnect"),
            onPressed: () async {
              await rf95.disconnect();
              rf95 = null;
              setState(() => false);
            }));
  }

  Widget _connectedDevicesTile() {
    return rf95 == null ? _defaultHint() : _connectedDevice();
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
            title: Text("Bluetooth is available.", style: TextStyle(color: Colors.white)),
          ),
        ),
        ListTile(
          title: Text("Connected device:"),
        ),
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
            ).then((_) => setState(() {}));
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
          onRefresh: () => FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Column(
                children: <Widget>[
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    initialData: [],
                    builder: (c, devices) {
                      // Filter scan results for connectable and named devices
                      List<ScanResult> connectables =
                          devices.data.where((r) => r.advertisementData.connectable && !r.device.name.isEmpty).toList();
                      // Sort scan result by RSSI
                      connectables.sort((a, b) => b.rssi.compareTo(a.rssi));
                      return Column(
                        children: connectables
                            .map(
                              (r) => ScanResultTile(r),
                            )
                            .toList(),
                      );
                    },
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

  void _connectAndReturn(BluetoothDevice device, BuildContext context) async {
    print("Connection to ${device.id} requested");
    String error = null;
    String device_name = device.name.isEmpty ? device.id.toString() : device.name;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Connecting to ${device_name}...'),
              content: Center(child: CircularProgressIndicator(), widthFactor: 1, heightFactor: 1),
            ));

    try {
      await device.connect().timeout(const Duration(seconds: 3));
      rf95 = RF95(device);

      print("Discovering services");
      List<BluetoothService> services = await device.discoverServices();

      print("Getting Service");
      BluetoothService service = services.firstWhere((s) => s.uuid == serviceUUID);

      print("Retrieving characteristics");
      rf95.readCharacteristic = service.characteristics.firstWhere((c) => c.uuid == readCharacteristicUUID);
      rf95.writeCharacteristic = service.characteristics.firstWhere((c) => c.uuid == writeCharacteristicUUID);
    } on StateError {
      error = "Service rf95modem is not available on ${device_name}.";
    } on TimeoutException {
      error = "Timeout connecting to rf95modem service on ${device_name}.";
    } catch (e) {
      error = "Unknown error connecting to device ${device_name}: ${e}";
    }

    Navigator.pop(context);

    if (error != null) {
      print(error);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Connection Failed'),
                content: Text(error),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context),
      leading: Text(result.rssi.toString() + "dB"),
      trailing: TextButton(
        child: Text('Connect'),
        onPressed: () => result.advertisementData.connectable ? _connectAndReturn(result.device, context) : null,
      ),
    );
  }
}

class BluetoothSettingsErrorScreen extends StatelessWidget {
  final String errorText;
  final IconData iconData;

  const BluetoothSettingsErrorScreen({Key key, this.errorText, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A3D91),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              iconData,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              errorText,
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
