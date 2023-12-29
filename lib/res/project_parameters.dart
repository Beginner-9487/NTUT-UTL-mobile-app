import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/page/line_chart/line_chart_page.dart';
import 'package:ntut_utl_mobile_app/page/splash_page.dart';

import '../page/account/login_page.dart';
import '../page/bluetooth/page/other_bluetooth_page.dart';
import '../page/home/home_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectParameters {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static late AppLocalizations str;

  static final Map<String, WidgetBuilder> routes = {
    LoginPage.ROUTER_NAME: (context) => const LoginPage(),
    HomePage.ROUTER_NAME: (context) => const HomePage()
  };
  static String stringLoginPageName = LoginPage.ROUTER_NAME;
  static String stringDefaultPageName = HomePage.ROUTER_NAME;
  static Widget widgetLoginPage = const LoginPage();
  static Widget widgetDefaultPage = SplashPageLoading();

  static List<PageStorageKey<int>> homePageKeys = [
    const PageStorageKey<int>(0),
    const PageStorageKey<int>(1),
  ];

  static Map<String, Widget> get homePageTabs => {
    str.ble_scanning_page: ScanBluetoothExamplePage(homePageKeys[0]),
    str.line_chart_page: SimpleLineChart(homePageKeys[1])
  };

  static bool get allowAutoLoginAsGuest => true;
  static bool get allowGiveAppFeedback => true;
  static bool get blocDebug => kDebugMode;
  static bool get logDebug => kDebugMode;
}

class TargetBLEUUID {
  static String get MackaySendUUID => "0000fff3-0000-1000-8000-00805f9b34fb";
  static String get MackaySubscribeUUID => "0000fff6-0000-1000-8000-00805f9b34fb";
}

mixin StatelessWidgetWithResStrings on StatelessWidget {
  late AppLocalizations str;
  Widget buildWithContext(BuildContext context);

  @override
  Widget build(BuildContext context) {
    str = AppLocalizations.of(context)!;
    return buildWithContext(context);
  }
}

mixin StateWithResStrings<T extends StatefulWidget> on State<T> {
  late AppLocalizations str;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    str = AppLocalizations.of(context)!;
  }
}