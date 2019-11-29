import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:convert/convert.dart';

import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/connectors/MessageParser.dart';

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

  List<int> readBuffer = <int>[];

  set writeCharacteristic(BluetoothCharacteristic characteristic) {
    this._wCharac = characteristic;
  }

  BluetoothCharacteristic get writeCharacteristic {
    return this._wCharac;
  }

  void onData(List<int> data) {
    if (data.last == "\n".codeUnits.first) {
      readBuffer.addAll(data);
      String completeMessage = decodeMessage(readBuffer);
      readBuffer = <int>[];

      handleRecvData(completeMessage);
    } else {
      readBuffer.addAll(data);
    }
  }

  set readCharacteristic(BluetoothCharacteristic characteristic) {
    this._rCharac = characteristic;
    this._rCharac.setNotifyValue(true);

    _rCharac.value.listen(onData);
  }

  BluetoothCharacteristic get readCharacteristic {
    return this._rCharac;
  }

  List<int> encodeMessage(Message msg) {
    final String completeMessage = msg.user + "|" + msg.channel + "|" + msg.timestamp + "|" + msg.text;
    return (sendCommand + hex.encode(utf8.encode(completeMessage)) + "\n").codeUnits;
  }

  Future send(Message msg) async {
    if (this.dev != null && this.writeCharacteristic != null) {
      await _wCharac.write(this.encodeMessage(msg));
    }
  }

  String decodeMessage(List<int> msg) {
    String entireMessage = utf8.decode(msg).split(",")[1];

    List<int> decodedHex = hex.decode(entireMessage);

    return new String.fromCharCodes(decodedHex);
  }

}
