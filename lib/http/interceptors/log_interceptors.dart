import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import '../../utils/print_long.dart';
import '../dio_util.dart';


bool isDebug = true;

///用于Dio的请求日志拦截器
class LogsInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (ProjectParameters.logDebug) {
      debugPrint("┌────────────────────────Begin Request────────────────────────");
      debugPrint("uri = ${options.uri}");
      debugPrint("method = ${options.method}");
//      print("请求url：${options.baseUrl}");
//      print("请求path：${options.path}");
//      print("query参数：${options.queryParameters}");
      debugPrint('headers: ' + options.headers.toString());
      if (options.data != null) {
        printLong('body: ' + options.data.toString());
      }
      debugPrint("└————————————————————————End Request——————————————————————————\n\n");
    }
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (ProjectParameters.logDebug) {
      if (response != null) {
        print("┌────────────────────────Begin Response————————————————————————");
        print('status ${response.statusCode}');
//        print('   ┌───────────header——————');
//        print('${response.headers.toString()}');
//        print('   └——————————————————————');
        printLong('response: ' + response.toString());
        print("└————————————————————————End Response——————————————————————————\n\n");
      }
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler,) {
    if (ProjectParameters.logDebug) {
      print("┌────────────────────────Begin Dio Error————————————————————————");
      print('请求异常: ' + err.toString());
      print('请求异常信息: ' + (err.response?.toString() ?? ""));
      print("└————————————————————————End Dio Error——————————————————————————\n\n");
    }
  }


}
