import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:convert/convert.dart';

import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/connectors/MessageParser.dart';

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
      if (data.isNotEmpty && utf8.decode(data.getRange(0, 3).toList()) == "+RX") {
        readBufferFilling = true;
      }
    }

    if (readBufferFilling && data.last == "\n".codeUnits.first) {
      readBuffer.addAll(data);
      String completeMessage = decodeMessage(readBuffer);
      readBuffer.clear();
      readBufferFilling = false;

      handleRecvData(completeMessage);
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

  List<int> encodeMessage(Message msg) {
    String location = msg.location.longitude.toString() + "," + msg.location.latitude.toString();
    final String completeMessage = msg.channel + "|" + msg.user + "|" + location + "|" + msg.text;
    return (sendCommand + hex.encode(utf8.encode(completeMessage)) + "\n").codeUnits;
  }

  Future send(Message msg) async {
    if (dev != null && this.writeCharacteristic != null) {
      await _wCharac.write(this.encodeMessage(msg));
    }
  }

  String decodeMessage(List<int> msg) {
    String entireMessage = utf8.decode(msg).split(",")[1];

    List<int> decodedHex = hex.decode(entireMessage);

    return new String.fromCharCodes(decodedHex);
  }

  void setMode(String mode) async {
    if (dev != null && this.writeCharacteristic != null) {
      List<int> cmd = (modeCommand + mode + '\n').codeUnits;
      await _wCharac.write(cmd);
    }
  }
}
