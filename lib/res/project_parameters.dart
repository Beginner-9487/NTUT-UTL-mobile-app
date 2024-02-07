import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_concrete_flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';
import 'package:ntut_utl_mobile_app/repository/experiment/experiment_mode_service_concrete_local_data.dart';
import 'package:ntut_utl_mobile_app/repository/experiment/experiment_mode_service_interface.dart';
import 'package:ntut_utl_mobile_app/repository/line_chart/line_chart_storage_concrete_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/repository/local/local_data_service_concrete_shared_preference.dart';
import 'package:ntut_utl_mobile_app/repository/login_page/login_page_data_concrete_local_data.dart';
import 'package:ntut_utl_mobile_app/repository/login_page/login_page_data_interface.dart';
import 'package:ntut_utl_mobile_app/repository/user/data/user_data_service_concrete_test.dart';
import 'package:ntut_utl_mobile_app/ui/screen/home_screen.dart';
import 'package:ntut_utl_mobile_app/ui/screen/login_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../repository/bluetooth/data_storage/ble_data_storage_interface.dart';
import '../repository/bluetooth/data_storage/foot/ble_data_storage_foot.dart';
import '../repository/bluetooth/data_storage/mackay_irb/ble_data_storage_mackay_irb.dart';
import '../repository/user/data/user_data_service_interface.dart';
import '../utils/screen_utils.dart';

class ProjectParameters {
  ProjectParameters._();

  static String get TEST_USER_DEFAULT_NAME => "UTL 實習生";
  static Widget TEST_USER_DEFAULT_AVATAR(double size) {
    return CachedNetworkImage(
      imageUrl: "",
      width: pt(size),
      height: pt(size),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(
        Icons.account_circle,
        color: Colors.white,
        size: pt(size),
      ),
    );
  }

  static BLEManager get bleManager => BLEManagerFBP();
  static UserDataService get userDataService => TestUserDataService();
  static LoginPageData get loginPageData => LoginPageDataLocalData(LocalDataServiceSharedPreference());
  static ExperimentModeService get experimentModeService => ExperimentModeServiceLocalData(LocalDataServiceSharedPreference());

  static const int BLUETOOTH_SCANNING_DURATION = 15;

  static BLEDataStorageEvent bleDataManagerServiceMackayIRB = BLEDataStorageEvent(BLEDataStorageMackayIRB());
  static BLEDataStorageEvent bleDataManagerServiceFoot = BLEDataStorageEvent(BLEDataStorageFoot());

  static  LineChartStorageMackayIRB lineChartStorageMackayIRB = LineChartStorageMackayIRB(bleDataManagerServiceMackayIRB);

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static PageStorageKey<int> get bluetoothScanTestViewKey => const PageStorageKey<int>(0);
  static PageStorageKey<int> get bluetoothScanMackay => const PageStorageKey<int>(1);
  static PageStorageKey<int> get lineChartViewKeyMackayIrb => const PageStorageKey<int>(2);
  static PageStorageKey<int> get lineChartDashboardViewKeyMackayIrb => const PageStorageKey<int>(3);
  static PageStorageKey<int> get lineChartViewKeyFoot => const PageStorageKey<int>(4);

  static final Map<String, WidgetBuilder> routes = {
    LoginScreen.ROUTER_NAME: (context) => const LoginScreen(),
    HomeScreen.ROUTER_NAME: (context) => const HomeScreen()
  };
  static String stringLoginPageName = LoginScreen.ROUTER_NAME;
  static String stringDefaultPageName = HomeScreen.ROUTER_NAME;
  static Widget widgetLoginPage = const LoginScreen();
  static Widget widgetDefaultPage = const HomeScreen();

  static bool get allowAutoLoginAsGuest => true;
  static bool get allowGiveAppFeedback => true;
  static bool get blocDebug => kDebugMode;
  static bool get logDebug => kDebugMode;
}

mixin StatelessWidgetWithResStrings on StatelessWidget {
  late BuildContext buildContext;
  AppLocalizations get str => AppLocalizations.of(buildContext)!;
  Widget buildWithContext(BuildContext context);

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return buildWithContext(context);
  }
}

mixin StatefulWithResStrings<T extends StatefulWidget> on State<T> {
  AppLocalizations get str => AppLocalizations.of(context)!;
}