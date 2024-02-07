import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

class FlutterBluePlusPeripheralManager {

  // ===========================================================================
  // adapterState
  static StreamSubscription<BluetoothAdapterState> bluetoothAdapterListen (void Function(BluetoothAdapterState state) doSomething) {
    return FlutterBluePlus.adapterState.listen((state) {
      doSomething(state);
    });
  }

  // ===========================================================================
  // isScanningNow
  static bool get isScanning => FlutterBluePlus.isScanningNow;
  static StreamSubscription<bool> isScanningSubscription (void Function(bool state) doSomething) {
    return FlutterBluePlus.isScanning.listen((state) {
      doSomething(state);
    });
  }

  // ===========================================================================
  // Bluetooth Turn
  static turnOn() async {
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }
  static turnOff() async {}

  // ===========================================================================
  // BluetoothDevice
  static List<BluetoothDevice> systemDevices = [];
  static scanOn() async {
    if(isScanning) {
      // scanOff();
      return;
    }
    try {
      systemDevices = await FlutterBluePlus.systemDevices;

      _scanResultsSubscription = scanResultsSubscription(
          (List<ScanResult> results) {
            debugPrint("_scanResultsSubscription: ${results.length}");
            scanResults = results;
          },
          error: (Exception exception) {
            debugPrint(exception.toString());
          }
      );

      // android is slow when asking for all advertisements,
      // so instead we only ask for 1/8 of them
      int divisor = Platform.isAndroid ? 8 : 1;
      await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: ProjectParameters.BLUETOOTH_SCANNING_DURATION),
          continuousUpdates: true,
          continuousDivisor: divisor
      );
    } catch (e) {
      debugPrint("ERROR: scanOn: $e");
    }
  }
  static scanOff() {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      debugPrint("ERROR: scanOff: $e");
    }
  }

  // ===========================================================================
  // ScanResult
  static List<ScanResult> scanResults = [];
  static StreamSubscription<List<ScanResult>> scanResultsSubscription (void Function(List<ScanResult> results) doSomething, {void Function(Exception)? error}) {
    return FlutterBluePlus.scanResults.listen((results) {
      doSomething(results);
    }, onError: (e) {
      error != null ? (e) : ();
    });
  }
  static late StreamSubscription<List<ScanResult>> _scanResultsSubscription;

  // ===========================================================================
  // connectedDevices
  static List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;

}