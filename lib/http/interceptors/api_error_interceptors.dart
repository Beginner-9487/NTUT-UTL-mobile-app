import '../index.dart';

class APIErrorInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // var data = options.data;
    //
    // if (data is String) {
    //   try {
    //     data = json.decode(data);
    //   } catch (e) {}
    // }
    //
    // if (data is Map) {
    //   int errorCode = data['errorCode'] ?? 0;
    //   String errorMsg = data['errorMsg'] ?? '请求失败[$errorCode]';
    //
    //   if (errorCode == -1001 /*未登录错误码*/) {
    //     dio.clear();
    //     goLogin();
    //     return dio.reject(errorMsg);
    //   } else if (errorCode < 0) {
    //     return dio.reject(errorMsg);
    //   } else {
    //     return response;
    //   }
    // }
  }

  void goLogin() {
    // navigatorKey.currentState.pushNamed(LoginWanandroidPage.ROUTER_NAME);
  }
}