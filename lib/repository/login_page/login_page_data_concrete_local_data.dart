import 'package:ntut_utl_mobile_app/repository/local/local_data_service_interface.dart';
import 'package:ntut_utl_mobile_app/repository/login_page/login_page_data_interface.dart';

class LoginPageDataLocalData extends LoginPageData {

  LocalDataService service;
  LoginPageDataLocalData(this.service);

  @override
  Future<bool> get wantedToRememberAccount async => await service.getData(service.key.WANT_TO_REMEMBER_ACCOUNT);
  @override
  Future setWantedToLoginAutomatically(bool value) async {
    await service.setData(service.key.WANT_TO_REMEMBER_ACCOUNT, value);
  }

  @override
  Future<bool> get wantedToLoginAutomatically async => await service.getData(service.key.WANT_TO_LOGGED_IN_AUTOMATICALLY);
  @override
  Future setWantedToRememberAccount(bool value) async {
    await service.setData(service.key.WANT_TO_LOGGED_IN_AUTOMATICALLY, value);
  }

  @override
  Future<String> getRememberedAccount() async {
    return await service.getData(service.key.REMEMBERED_USER_ACCOUNT);
  }
}