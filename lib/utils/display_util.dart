import 'package:flutter/material.dart';

import '../http/dio_util.dart';
import '../res/colors.dart';

///统一风格的常用 UI 展示
class DisplayUtil {
  ///通用 toast。context 必须是 Scaffold 的子树
  static void showMsg(
    BuildContext context, {
    String? text,
    Exception? exception,
    bool? isErrorMsg,
    Duration duration = const Duration(seconds: 2, milliseconds: 500),
  }) {
    isErrorMsg ??= (exception != null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 4,
        backgroundColor: isErrorMsg ? WColors.warning_red : null,
        content: Text(
          text ?? DioUtil.parseError(exception),
          style: const TextStyle(color: Colors.white),
        ),
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  ///比直接设置elevation的悬浮感更轻薄的背景阴影
  static BoxShadow lightElevation({Color baseColor = const Color(0xFFEEEEEE)}) {
    return BoxShadow(
      color: baseColor,
      blurRadius: 9,
      spreadRadius: 3,
    );
  }

  static BoxShadow superLightElevation({Color baseColor = const Color(0xFFEEEEEE)}) {
    return BoxShadow(
      color: baseColor,
      blurRadius: 6,
    );
  }
}
