import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_concrete_flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';
import 'package:ntut_utl_mobile_app/ui/screen/flutter_blue_plus_example/made_by_me/device_screen_write_input_value.dart';


class DeviceScreenAdaptorWriteInputValue {
  static Widget getScreen(BLEDevice device) {
    return DeviceScreenWriteInputValue(device: (device as BLEDeviceFBP).device);
  }
}