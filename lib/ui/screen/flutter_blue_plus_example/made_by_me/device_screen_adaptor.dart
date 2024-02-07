import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_concrete_flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';
import 'package:ntut_utl_mobile_app/ui/screen/flutter_blue_plus_example/device_screen.dart';


class DeviceScreenAdaptor {
  static Widget getScreen(BLEDevice device) {
    return DeviceScreen(device: (device as BLEDeviceFBP).device);
  }
}