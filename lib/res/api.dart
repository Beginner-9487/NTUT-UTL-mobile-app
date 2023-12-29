import 'dart:convert';

import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

import '../entity/user_entity.dart';
import '../http/dio_util.dart';
import '../http/index.dart';

class FakeApi {
  static bool get fakeUserTest => true;
  static String get fakeAPIBaseURL => "https://jsonplaceholder.typicode.com/todos";
  static Future<Response> fakeAPIResponse() {
    Response dioResponse = Response(
        requestOptions: RequestOptions(),
        data: fakeUserJson,
        statusCode: 200
    );
    Future<Response> futureResponse = Future.value(dioResponse);
    return futureResponse;
  }
  static String get fakeUserJson => jsonEncode(
      {
        "account":"utl@gmail.com",
        "username":"UTL 實習生",
        "id":"00001",
        "avatar_path":""
      }
  );
}

class Api {
  static String get BASE_URL => !FakeApi.fakeUserTest ? "https://www.wanandroid.com" : FakeApi.fakeAPIBaseURL;
  static int get ERROR_CODE_UN_LOGIN => -1001;
}

///对于调用层涉及传入页码的，统一从1开始。

///账户相关接口
class AccountApi {
  static const String LOGIN_PATH = "/user/login";
  static const String REGIST_PATH = "/user/register";
  static const String LOGOUT_PATH = "/user/logout/json";

  static Future<Response> login_by_username_password(String username, String password) {
    if(FakeApi.fakeUserTest) {
      return FakeApi.fakeAPIResponse();
    }
    return dio.post(LOGIN_PATH, queryParameters: {
      "username": username,
      "password": password,
    });
  }

  static Future<Response> getToken(accessToken) {
    if(FakeApi.fakeUserTest) {
      return FakeApi.fakeAPIResponse();
    }
    return dio.post(LOGIN_PATH, queryParameters: {
      "access_token": accessToken,
    });
  }

  static Future<Response> login_by_token(String accessToken) {
    if(FakeApi.fakeUserTest) {
      return FakeApi.fakeAPIResponse();
    }
    return dio.post(LOGIN_PATH, queryParameters: {
      "access_token": accessToken,
    });
  }

  static Future<Response> register(
      String username, String password, String repassword) {
    if(FakeApi.fakeUserTest) {
      return FakeApi.fakeAPIResponse();
    }
    return dio.post(REGIST_PATH, queryParameters: {
      "username": username,
      "password": password,
      "repassword": repassword,
    });
  }

  static Future<Response> logout() {
    if(FakeApi.fakeUserTest) {
      return FakeApi.fakeAPIResponse();
    }
    return dio.get(LOGOUT_PATH);
  }
}
