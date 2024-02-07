import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_concrete_flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';
import 'package:ntut_utl_mobile_app/ui/widgets/flutter_blue_plus_example/scan_result_tile.dart';
import 'package:ntut_utl_mobile_app/ui/widgets/flutter_blue_plus_example/system_device_tile.dart';

class BluetoothDeviceTileAdaptor {
  static Widget getScreen(
      BLEDevice device,
      {
        VoidCallback? onTap,
        VoidCallback? onOpen,
        VoidCallback? onConnect
      }
      ) {
    BLEDeviceFBP bleDeviceFBP = (device as BLEDeviceFBP);
    return (bleDeviceFBP.result != null) ?
    ScanResultTile(result: bleDeviceFBP.result!, onTap: onTap) :
    SystemDeviceTile(device: bleDeviceFBP.device, onOpen: onOpen!, onConnect: onConnect!);
  }
}