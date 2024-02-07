abstract class LoginPageData {

  Future<bool> get wantedToRememberAccount;
  Future setWantedToRememberAccount(bool value);

  Future<bool> get wantedToLoginAutomatically;
  Future setWantedToLoginAutomatically(bool value);

  Future<String> getRememberedAccount();

  Future<String> autoEnterAccount() async {
    return await wantedToRememberAccount ? await getRememberedAccount() : "";
  }
}