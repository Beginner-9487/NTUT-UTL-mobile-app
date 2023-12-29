import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import '../res/api.dart';
import 'interceptors/log_interceptors.dart';
import 'interceptors/api_error_interceptors.dart';

Dio _dio = Dio();

Dio get dio => _dio;

class DioUtil {
  static Future init() async {
    dio.options.baseUrl = Api.BASE_URL;
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.sendTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);

    //todo 网络环境监听
    dio.interceptors.add(LogsInterceptors());
    dio.interceptors.add(APIErrorInterceptors());

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = "${tempDir.path}/dioCookie";
    debugPrint('DioUtil : http cookie path = $tempPath');
    CookieJar cj = PersistCookieJar(
        // ignoreExpires: true,
        storage: FileStorage(tempPath)
    );
    dio.interceptors.add(CookieManager(cj));
  }

  static String parseError(error, {String defErrorString = '网络连接超时或者服务器未响应'}) {
    String? errStr;
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        errStr = defErrorString;
      } else {
        errStr = error.message;
      }
    }
    return errStr ?? defErrorString;
  }
}
