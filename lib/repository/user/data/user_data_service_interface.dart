import 'package:flutter/cupertino.dart';

abstract class UserDataService {
  bool get isLoggedIn;
  bool get isGuest;
  bool get isAdministrator;

  String get userAccount;
  String get username;
  Future<bool> changeUsername(String newUsername);
  String get userId;
  String get avatarPath;
  Widget avatar(double size);

  Future<bool> login(String userAccount, String password);
  Future<bool> loginAsGuest();
  Future<bool> loginAutomatically();
  Future<bool> logout();
  Future<bool> refresh();
}