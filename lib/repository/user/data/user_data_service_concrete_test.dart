import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ntut_utl_mobile_app/repository/user/data/user_data_service_interface.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

class TestUserDataService extends UserDataService {
  @override
  bool isLoggedIn = false;

  @override
  bool isGuest = false;

  @override
  bool isAdministrator = false;

  @override
  String userAccount = "";

  static String usernameStoredInDatabase = ProjectParameters.TEST_USER_DEFAULT_NAME;
  @override
  String username = usernameStoredInDatabase;
  @override
  Future<bool> changeUsername(String newUsername) async {
    usernameStoredInDatabase = newUsername;
    return true;
  }

  @override
  String userId = "";

  @override
  String avatarPath = "";

  @override
  Widget avatar(double size) {
    return ProjectParameters.TEST_USER_DEFAULT_AVATAR(size);
  }

  @override
  Future<bool> login(String userAccount, String password) async {
    isLoggedIn = true;
    isGuest = true;
    isAdministrator = false;
    username = "UTL Login";
    this.userAccount = userAccount;
    userId = "ID-00010";
    return true;
  }
  @override
  Future<bool> loginAsGuest() async {
    isLoggedIn = true;
    isGuest = false;
    isAdministrator = false;
    username = "UTL Guest";
    userAccount = "test@gmail.com";
    userId = "ID-00001";
    return true;
  }
  @override
  Future<bool> loginAutomatically() async {
    isLoggedIn = true;
    isGuest = false;
    isAdministrator = false;
    username = "UTL Automatically";
    userAccount = "test@gmail.com";
    userId = "ID-00001";
    return true;
  }

  @override
  Future<bool> logout() async {
    isLoggedIn = false;
    isGuest = false;
    isAdministrator = false;
    return true;
  }

  @override
  Future<bool> refresh() async {
    return true;
  }
}