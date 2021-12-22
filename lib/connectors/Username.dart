import 'package:shared_preferences/shared_preferences.dart';
import 'package:bluera/data/Globals.dart';

final String _usernameKey = "username";

class UsernameConnector {
  static void write(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(_usernameKey, username);
  }

  static Future<String> read() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    localUser = prefs.getString(_usernameKey) ?? null;
    localUserNotifier.notifyListeners();

    return localUser;
  }
}
