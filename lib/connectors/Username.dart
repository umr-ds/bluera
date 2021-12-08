import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:bluera/data/Globals.dart';

class UsernameConnector {
  static void write(String text) {
    getApplicationDocumentsDirectory().then((directory) {
      final File file = File('${directory.path}/$usernameFileName');
      file.writeAsStringSync(text);
    });
  }

  static Future<String> read() async {
    Directory applicationDocuments = await getApplicationDocumentsDirectory();
    File file = File('${applicationDocuments.path}/$usernameFileName');
    try {
      localUser = file.readAsStringSync();
      localUserNotifier.notifyListeners();
    } catch (e) {
      print("An error occured while reading the username file: " + e.toString());
    }
    return localUser;
  }
}
