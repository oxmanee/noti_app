import 'package:shared_preferences/shared_preferences.dart';

class manageUser {
  save(String username) async {
    final prefes = await SharedPreferences.getInstance();
    final keyUser = 'username';
    final valueUser = username;

    prefes.setString(keyUser, valueUser);
  }

  clearData() async {
    final prefes = await SharedPreferences.getInstance();
    prefes.clear();
  }

  readUser() async {
    final prefes = await SharedPreferences.getInstance();
    final key = 'username';
    final value = prefes.getString(key) ?? 0;
    return value;
  }
}
