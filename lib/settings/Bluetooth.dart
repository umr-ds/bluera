import 'package:flutter_blue/flutter_blue.dart';

Guid serviceUUID = new Guid("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
Guid writeCharacteristicUUID = new Guid("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");

BluetoothDevice bluetoothDev;
BluetoothCharacteristic writeCharacteristic;
