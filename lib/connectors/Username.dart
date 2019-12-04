import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:BlueRa/data/Globals.dart';

class UsernameConnector {
  static void write(String text) {
    getApplicationDocumentsDirectory().then((directory) {
      final File file = File('${directory.path}/$usernameFileName');
      file.writeAsStringSync(text);
    });
  }

  static void read() {
    getApplicationDocumentsDirectory().then((directory) {
      File file = File('${directory.path}/$usernameFileName');
      try {
        localUser = file.readAsStringSync();
      } catch (e) {
        print("An error occured while reading the username file: " + e.toString());
      }
    });
  }
}
