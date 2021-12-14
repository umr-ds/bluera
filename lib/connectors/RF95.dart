import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:convert/convert.dart';

import 'package:bluera/data/Message.dart';
import 'package:bluera/connectors/MessageParser.dart';

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

  // List<int> readBuffer = <int>[];
  var readBuffer = "";
  // bool readBufferFilling = false;

  set writeCharacteristic(BluetoothCharacteristic characteristic) {
    this._wCharac = characteristic;
  }

  BluetoothCharacteristic get writeCharacteristic {
    return _wCharac;
  }

  Future disconnect() async {
    readBuffer = "";

    _wCharac = null;

    _rCharac.setNotifyValue(false);
    _rCharac.value.listen(null);
    _sub.cancel();
    _rCharac = null;

    await dev.disconnect();
    dev = null;
  }

  void onData(List<int> data) {
    // decode data and read data into buffer
    readBuffer += utf8.decode(data);

    int lineEnd = readBuffer.indexOf("\n");

    // continue reading, while lineEnd does exist
    while (-1 != (lineEnd = readBuffer.indexOf("\n"))) {
      // extract line and remain rest in buffer
      String line = readBuffer.substring(0, lineEnd);
      readBuffer = readBuffer.substring(lineEnd + 1, readBuffer.length);
      print("Remaining read buffer: '$readBuffer' (len: ${readBuffer.length})");

      // received AT response
      if (line.startsWith("+")) {
        if (line.substring(1, 3) == "RX") {
          List<String> parts = line.substring(4).split(",");

          // get msg length
          int len = int.parse(parts[0]);

          // hex-decode message
          List<int> decodedHex = hex.decode(parts[1]);
          var msg = String.fromCharCodes(decodedHex);

          int rssi = int.parse(parts[2]);
          int snr = int.parse(parts[3]);

          print("Received $len bytes (RSSI: $rssi, SNR: $snr): $msg");

          handleRecvData(msg);
        } else {
          print("Unknown command: $line");
        }
      } else {
        // non AT response
        print("Unknown: $line");
      }
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

  // String decodeMessage(List<int> msg) {
  //   String entireMessage = utf8.decode(msg).split(",")[1];

  //   List<int> decodedHex = hex.decode(entireMessage);

  //   return new String.fromCharCodes(decodedHex);
  // }

  void setMode(String mode) async {
    if (dev != null && this.writeCharacteristic != null) {
      List<int> cmd = (modeCommand + mode + '\n').codeUnits;
      await _wCharac.write(cmd);
    }
  }
}
