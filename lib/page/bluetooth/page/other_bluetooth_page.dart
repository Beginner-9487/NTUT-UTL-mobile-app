import 'package:flutter/cupertino.dart';
import 'package:ntut_utl_mobile_app/page/bluetooth/screens/scan_example_screen.dart';

import 'bluetooth_page.dart';

class ScanBluetoothExamplePage extends BluetoothExamplePage {
  ScanBluetoothExamplePage(super.pageStorageKey, {super.key});

  @override
  static get ROUTER_NAME => '/ScanBluetoothExamplePage';

  @override
  Widget get targetScreen => const ScanExampleScreen();
}