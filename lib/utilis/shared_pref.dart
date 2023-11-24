import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

sealed class SharedPref {
  static Future<void> saveUserDataToPrefs(
      {UserCredential? userCredential,
      Map? user,
      bool isMobileAuth = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isMobileAuth) {
      prefs.setString('user_uid',
          user == null || user['id'] == null ? '' : user['id'].toString());
      prefs.setString(
          'user_email',
          user == null || user['email'] == null
              ? ''
              : user['email'].toString());
      return;
    }
    prefs.setString('user_uid', userCredential?.user?.uid ?? '');
    prefs.setString('user_email', userCredential?.user?.email ?? '');
  }
}
