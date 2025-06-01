import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token'); // Gunakan key yang sama: 'user_token'
  }

  static Future<void> clearUserToken() async { // Untuk logout nanti
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
  }
}