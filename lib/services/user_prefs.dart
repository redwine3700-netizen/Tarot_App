import 'package:shared_preferences/shared_preferences.dart';

const String kUserNameKey = 'user_name';
const String kPreferredSignKey = 'preferred_sign';

class UserPrefs {
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(kUserNameKey) ?? '').trim();
  }

  static Future<void> setUserName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kUserNameKey, value.trim());
  }

  static String formatName(String name) {
    final n = name.trim();
    if (n.isEmpty) return '';
    return n.length > 18 ? n.substring(0, 18) : n;
  }
}
