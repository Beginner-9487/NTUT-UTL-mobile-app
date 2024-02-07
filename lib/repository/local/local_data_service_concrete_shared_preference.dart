import 'package:ntut_utl_mobile_app/repository/local/local_data_service_interface.dart';
import 'package:ntut_utl_mobile_app/res/local_data_enum.dart';
import 'package:ntut_utl_mobile_app/utils/shared_preference_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataServiceSharedPreference implements LocalDataService<LocalDataEnum> {

  @override
  Future setData(LocalDataEnum x, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferencesUtil(prefs, x.dataName, x.dataType).setValue(value);
  }

  @override
  Future<dynamic> getData(LocalDataEnum x, [dynamic defaultValue]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return SharedPreferencesUtil(prefs, x.dataName, x.dataType).getValue(defaultValue: defaultValue);
  }

  @override
  LocalDataEnum get key => LocalDataEnum(0, "");

}