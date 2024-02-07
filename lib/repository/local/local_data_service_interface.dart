abstract class LocalDataService<LocalEnum> {
  Future setData(LocalEnum localEnum, dynamic value);
  Future<dynamic> getData(LocalEnum localEnum, [dynamic defaultValue]);
  LocalEnum get key;
}