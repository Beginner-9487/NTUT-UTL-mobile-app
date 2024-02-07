import 'package:ntut_utl_mobile_app/utils/shared_preference_util.dart';

class LocalDataEnum {
  int dataType;
  String dataName;
  LocalDataEnum(this.dataType, this.dataName);

  static get WANT_TO_REMEMBER_ACCOUNT => LocalDataEnum(SharedPreferencesUtil.BOOL, "WANT_TO_REMEMBER_ACCOUNT");
  static get WANT_TO_LOGGED_IN_AUTOMATICALLY => LocalDataEnum(SharedPreferencesUtil.BOOL, "WANT_TO_LOGGED_IN_AUTOMATICALLY");
  static get REMEMBERED_USER_ACCOUNT => LocalDataEnum(SharedPreferencesUtil.STRING, "REMEMBERED_USER_ACCOUNT");
  static get EXPERIMENT => LocalDataEnum(SharedPreferencesUtil.INT, "EXPERIMENT");
}