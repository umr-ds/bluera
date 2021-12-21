import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:convert/convert.dart';

import 'package:bluera/data/Message.dart';
import 'package:bluera/connectors/MessageParser.dart';

Guid serviceUUID = new Guid("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
Guid writeCharacteristicUUID = new Guid("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");
Guid readCharacteristicUUID = new Guid("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");

RF95 rf95;

class RF95 {
  RF95(this.dev);

  BluetoothDevice dev;
  Completer _ok;

  BluetoothCharacteristic _wCharac;
  BluetoothCharacteristic _rCharac;

  StreamSubscription<dynamic> _sub;

  // Info
  String _firmware;
  int _mode;
  double _frequency;

  var readBuffer = "";

  BluetoothCharacteristic get writeCharacteristic {
    return _wCharac;
  }

  Future connect() async {
    await dev.connect();

    print("Discovering services");
    List<BluetoothService> services = await dev.discoverServices();

    print("Getting Service");
    BluetoothService service = services.firstWhere((s) => s.uuid == serviceUUID);

    print("Retrieving characteristics");
    _rCharac = service.characteristics.firstWhere((c) => c.uuid == readCharacteristicUUID);
    _rCharac.setNotifyValue(true);
    _sub = _rCharac.value.listen(onData);

    _wCharac = service.characteristics.firstWhere((c) => c.uuid == writeCharacteristicUUID);

    // wait 100 ms to finish up connection, see https://github.com/pauldemarco/flutter_blue/issues/331#issuecomment-652423102
    await Future.delayed(Duration(milliseconds: 100));

    print("Query device info");
    await info();

    print("rf95modem, firmware ${_firmware}, mode ${_mode}, freq ${_frequency} is initialized");
  }

  Future disconnect() async {
    readBuffer = "";

    _wCharac = null;

    _rCharac?.setNotifyValue(false);
    _rCharac?.value?.listen(null);
    _sub?.cancel();
    _rCharac = null;

    await dev?.disconnect();
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
      print("Received line: '${line}'");

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
        } else if (line.substring(1, 3) == "OK" || line.substring(1, 5) == "SENT") {
          if (_ok == null) {
            print("Received '${line}' without open request.");
          } else if (_ok.isCompleted) {
            print("Latest request was already satisfied.");
          } else {
            _ok.complete();
          }
        } else if (line.substring(1, 5) == "FREQ") {
          if (_ok == null) {
            print("Received '${line}' without open request.");
          } else if (_ok.isCompleted) {
            print("Latest request was already satisfied.");
          } else {
            _ok.complete();
          }
          _frequency = double.parse(line.split(":")[1]);
        } else {
          print("Unknown command: $line");
        }
      } else if (line.contains(":")) {
        List<String> parts = line.split(":");
        switch (parts[0]) {
          case "firmware":
            _firmware = parts[1].trim();
            break;
          case "modem config":
            _mode = int.parse(parts[1].split("|")[0]);
            break;
          case "frequency":
            _frequency = double.parse(parts[1]);
            break;
          default:
        }
      } else {
        // non AT response
        print("Unknown: $line");
      }
    }
  }

  void tx(Message msg) async {
    String location = msg.location.longitude.toString() + "," + msg.location.latitude.toString();
    String completeMessage = msg.channel + "|" + msg.user + "|" + location + "|" + msg.text;

    await _write("AT+TX=" + hex.encode(utf8.encode(completeMessage)));
  }

  int get mode {
    return _mode;
  }

  void setMode(int mode) async {
    await _write("AT+MODE=" + mode.toString());
    _mode = mode;
  }

  void info() async {
    await _write("AT+INFO");
  }

  double get freq {
    return _frequency;
  }

  void setFreq(double freq) async {
    await _write("AT+FREQ=" + freq.toString());
    _frequency = freq;
  }

  void _write(String cmd) async {
    // if there is an open request, await the result
    if (_ok != null) await _ok.future;

    // open new request and wait for result
    _ok = new Completer();
    await _wCharac.write((cmd + "\n").codeUnits);
    await _ok.future;
  }
}
