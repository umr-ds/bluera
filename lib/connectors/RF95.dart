import 'dart:async';
import 'dart:convert';

import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/data/Message.g.m8.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:BlueRa/data/Message.dart';

Guid serviceUUID = new Guid("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
Guid writeCharacteristicUUID = new Guid("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");
Guid readCharacteristicUUID = new Guid("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");

String sendCommand = "AT+TX=";
String modeCommand = "AT+MODE=";

RF95 rf95;

class RF95 {
  RF95(this.dev);

  BluetoothDevice dev;

  BluetoothCharacteristic _wCharac;
  BluetoothCharacteristic _rCharac;

  StreamSubscription<dynamic> _sub;

  List<int> readBuffer = <int>[];
  bool readBufferFilling = false;

  set writeCharacteristic(BluetoothCharacteristic characteristic) {
    this._wCharac = characteristic;
  }

  BluetoothCharacteristic get writeCharacteristic {
    return _wCharac;
  }

  Future disconnect() async {
    readBuffer.clear();

    _wCharac = null;

    _rCharac.setNotifyValue(false);
    _rCharac.value.listen(null);
    _sub.cancel();
    _rCharac = null;

    await dev.disconnect();
    dev = null;
  }

  void onData(List<int> data) {
    if (!readBufferFilling) {
      if (data.isNotEmpty &&
          utf8.decode(data.getRange(0, 3).toList()) == "+RX") {
        readBufferFilling = true;
      }
    }

    if (readBufferFilling && data.last == "\n".codeUnits.first) {
      readBuffer.addAll(data);

      String readBufferString = utf8.decode(readBuffer);
      readBuffer.clear();
      readBufferFilling = false;

      List<String> readBufferList = readBufferString.split(",");
      print(readBufferList);

      MessageProxy msg = MessageProxyConstructor.fromHex(
        readBufferList[1],
        int.parse(readBufferList[2]),
        int.parse(readBufferList[3]),
      );
      databaseProvider.saveMessage(msg);
      recvNotifier.notifyListeners();
    } else {
      readBuffer.addAll(data);
    }
  }

  set readCharacteristic(BluetoothCharacteristic characteristic) {
    _rCharac = characteristic;
    _rCharac.setNotifyValue(true);

    _sub = _rCharac.value.listen(onData);
  }

  BluetoothCharacteristic get readCharacteristic {
    return _rCharac;
  }

  Future send(Message msg) async {
    if (dev != null && this.writeCharacteristic != null) {
      List<int> btBytes = (sendCommand + msg.toHex() + "\n").codeUnits;
      await _wCharac.write(btBytes);
    }
  }

  void setMode(String mode) async {
    if (dev != null && this.writeCharacteristic != null) {
      List<int> cmd = (modeCommand + mode + '\n').codeUnits;
      await _wCharac.write(cmd);
    }
  }
}
