import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:convert/convert.dart';

import 'package:BlueRa/data/Message.dart';

Guid serviceUUID = new Guid("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
Guid writeCharacteristicUUID = new Guid("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");
Guid readCharacteristicUUID = new Guid("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");

String sendCommand = "AT+TX=";

RF95 rf95;

class RF95 {
  RF95(this.dev);

  BluetoothDevice dev;

  BluetoothCharacteristic _wCharac;
  BluetoothCharacteristic _rCharac;

  set writeCharacteristic(BluetoothCharacteristic characteristic) {
    this._wCharac = characteristic;
  }

  BluetoothCharacteristic get writeCharacteristic {
    return this._wCharac;
  }

  set readCharacteristic(BluetoothCharacteristic characteristic) {
    this._rCharac = characteristic;
  }

  BluetoothCharacteristic get readCharacteristic {
    return this._rCharac;
  }

  List<int> preparedMessage(Message msg) {
    final String completeMessage = msg.user.name + "|" + msg.channel + "|" + msg.timestamp + "|" + msg.text;
    return (sendCommand + hex.encode(utf8.encode(completeMessage)) + "\n").codeUnits;
  }

  Future send(Message msg) async {
    if (this.dev != null && this.writeCharacteristic != null) {
      await _wCharac.write(this.preparedMessage(msg));
    }
  }
}
