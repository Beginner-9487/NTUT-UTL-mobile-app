import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ntut_utl_mobile_app/entity/user_entity.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import '../res/api.dart';
import '../utils/display_util.dart';
import '../utils/shared_preference_util.dart';

class MyUserRepository {
  static UserEntity currentUserEntity = UserEntity.getIllegalUserEntity();

  static bool get isLoggedIn => currentUserEntity.runtimeType != IllegalUserEntity;
  static String accessToken = "";
  static String refreshToken = "";
  static String getToken() {
    AccountApi.getToken(accessToken).then((value) => {
      MyUserRepository._$getAccessRefreshTokenByJson(json.decode(value.data))
    });
    return accessToken;
  }
  static void _$getAccessRefreshTokenByJson(Map<String, dynamic> json) {
    accessToken = json['access_token'] as String;
    accessToken = json['refresh_token'] as String;
  }

  static Future<bool> auto_login(BuildContext context) async {
    debugPrint("auto_login: ${await SharedPreferencesUtil.getWantToStayLoggedIn()}");
    if(MyUserRepository.isLoggedIn) {
      return true;
    }
    try {
      await AccountApi.login_by_token(
        getToken()
      ).then((value) => {
        currentUserEntity = UserEntity.fromJson(
            json.decode(value.data)
        )
      });
      print("currentUserEntity: ${currentUserEntity.username}");
      return true;
    } catch (e) {
      print("auto_login: ${e}");
      if(ProjectParameters.allowAutoLoginAsGuest) {
        currentUserEntity = UserEntity.getGuestUserEntity();
      }
      DisplayUtil.showMsg(context, exception: e as Exception);
    }
    return false;
  }

  static Future<UserEntity> force_to_logged_in(BuildContext context) async {
    bool isLoggedIn = false;
    await auto_login(context).then((value) => {isLoggedIn = value});
    print("force_to_logged_in: ${isLoggedIn}");
    String target = isLoggedIn ? ProjectParameters.stringDefaultPageName : ProjectParameters.stringLoginPageName;
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    while (parentRoute?.canPop ?? false) {
      Navigator.of(context).pop(true);
    }
    Navigator.pushReplacementNamed(context, target)
        .then((_) {
    });
    return MyUserRepository.currentUserEntity;
  }
}