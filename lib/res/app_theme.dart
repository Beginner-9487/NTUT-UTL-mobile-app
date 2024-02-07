import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/res/app_colors.dart';
import 'package:ntut_utl_mobile_app/utils/other_useful_function.dart';

class AppTheme {
  AppTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color darkGrey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'WorkSans';

  static Color colorHomeDrawerBackground(BuildContext context) {
    return AppTheme.notWhite.withOpacity(0.5);
  }

  static Color colorDrawerControllerIcon(BuildContext context) {
    return OtherUsefulFunction.isLightMode(context) ? AppTheme.darkGrey : AppTheme.white;
  }

  static Color colorDrawerControllerBackground(BuildContext context) {
    return OtherUsefulFunction.isLightMode(context) ? AppTheme.white : AppTheme.nearlyBlack;
  }

  static Color colorNavigationHomeScreenBackground(BuildContext context) {
    return AppTheme.nearlyWhite;
  }

  static Color colorNavigationHomeScreen(BuildContext context) {
    return AppTheme.white;
  }

  static TextStyle textStyleHomeDrawerUsername(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: OtherUsefulFunction.isLightMode(context) ? AppTheme.grey : AppTheme.white,
      fontSize: 18,
    );
  }

  static TextStyle textStyleDrawerText(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: OtherUsefulFunction.isLightMode(context) ? AppTheme.grey : AppTheme.white,
      fontSize: 18,
    );
  }

  static Divider divider(BuildContext context) {
    return Divider(
      height: 1,
      color: AppTheme.grey.withOpacity(0.6),
    );
  }

  /// ==========================================================================
  static TextStyle textStyleHeader(BuildContext context) {
    return TextStyle( // h5 -> headline
      fontFamily: fontName,
      fontWeight: FontWeight.bold,
      fontSize: 24,
      letterSpacing: 0.27,
      color: OtherUsefulFunction.isLightMode(context) ? darkText : notWhite,
    );
  }
  static Color colorHeader(BuildContext context) {
    return OtherUsefulFunction.isLightMode(context) ? nearlyWhite : nearlyBlack;
  }

  ///通用tosat。context必须是Scaffold的子树
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
        backgroundColor: isErrorMsg ? AppColors.warning_red : null,
        content: Text(
          text ??= "",
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

  static Color colorBLEConnectedBackground(BuildContext context) {
    return OtherUsefulFunction.isLightMode(context) ? const Color(0xC01085F2) : const Color(0xC032A7F3);
  }

  static Color colorBLEDisconnectedBackground(BuildContext context) {
    return OtherUsefulFunction.isLightMode(context) ? const Color(0xC0FB4747) : const Color(0xC0FB6969);
  }
}