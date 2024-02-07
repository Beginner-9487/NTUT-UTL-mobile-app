import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {

  static const int BOOL = 0;
  static const int INT = 1;
  static const int STRING = 2;

  SharedPreferences prefs;
  String target;
  int type;
  SharedPreferencesUtil(this.prefs, this.target, this.type);

  Future setValue(dynamic value) async {
    switch (type) {
      case BOOL:
        return prefs.setBool(target, value);
      case INT:
        return prefs.setInt(target, value);
      case STRING:
        return prefs.setString(target, value);
    }
  }

  Future<dynamic> getValue({dynamic defaultValue}) async {
    switch (type) {
      case BOOL:
        return prefs.get(target) ?? defaultValue ?? false;
      case INT:
        return prefs.get(target) ?? defaultValue ?? 0;
      case STRING:
        return prefs.get(target) ?? defaultValue ?? '';
    }
  }

}