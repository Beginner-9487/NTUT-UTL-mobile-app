import 'package:shared_preferences/shared_preferences.dart';

///一些通用SharedPreferences key声明处
class SPKey {
  static const String WANT_TO_STAY_LOGGED_IN = "want_to_stay_logged_in";
  static const String USER_ACCOUNT = "user_account";
  static const String USER_PASSWORD = "user_password";
  static const String USER_ACCESS_TOKEN = "user_access_token";
  static const String USER_REFRESH_TOKEN = "user_refresh_token";
}

class SharedPreferencesUtil {
  static Future setWantToStayLoggedIn(bool isLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SPKey.WANT_TO_STAY_LOGGED_IN, isLogin ?? false);
  }

  static Future<bool> getWantToStayLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SPKey.WANT_TO_STAY_LOGGED_IN) ?? false;
  }

  static Future setUserAccount(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(SPKey.USER_ACCOUNT, userName);
  }

  static Future getUserAccount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(SPKey.USER_ACCOUNT) ?? '';
  }

  static Future setUserPassword(String userPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(SPKey.USER_PASSWORD, userPassword);
  }

  static Future getUserPassword() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(SPKey.USER_PASSWORD) ?? '';
  }

  static Future setAccessToken(String userPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(SPKey.USER_ACCESS_TOKEN, userPassword);
  }

  static Future getAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(SPKey.USER_ACCESS_TOKEN) ?? '';
  }

  static Future setRefreshToken(String userPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(SPKey.USER_REFRESH_TOKEN, userPassword);
  }

  static Future getRefreshToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(SPKey.USER_REFRESH_TOKEN) ?? '';
  }
}
