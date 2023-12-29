import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'my_bluetooth_device_repository.dart';

class MyBluetoothRepository {
  static BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  static List<MyBluetoothDeviceRepository> systemDevicesRepository = [];
  static List<MyBluetoothDeviceRepository> scanResultsDevicesRepository = [];
  static List<MyBluetoothDeviceRepository> getAllDevicesRepository() {
    List<MyBluetoothDeviceRepository> list = [];
    list.addAll(scanResultsDevicesRepository);
    list.addAll(
        systemDevicesRepository.where((s) =>
        !list.any((l) => l.device.remoteId == s.device.remoteId))
    );
    return list;
  }
  static List<ScanResult> scanResults = [];
  static bool get isScanning => FlutterBluePlus.isScanningNow;
  static List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;

  static MyBluetoothDeviceRepository? getDeviceRepository(BluetoothDevice device) {
    for (MyBluetoothDeviceRepository d in getAllDevicesRepository()) {
      if(device.remoteId == d.device.remoteId) {
        return d;
      }
    }
  }

  static List<BluetoothDevice> get getAllDevices => getAllDevicesRepository().map((item) => item.device).toList();
  static List<BluetoothDevice> get getSystemDevices => systemDevicesRepository.map((item) => item.device).toList();
  static List<BluetoothDevice> get getConnectedDevices => getAllDevicesRepository().where((item) => item.currentConnectionState == BluetoothConnectionState.connected).toList().map((item) => item.device).toList();
  static List<BluetoothDevice> get getNonConnectedDevices => getAllDevicesRepository().where((item) => item.currentConnectionState != BluetoothConnectionState.connected).toList().map((item) => item.device).toList();

  static StreamSubscription<BluetoothAdapterState> bluetoothAdapterListen ({void Function()? doSomething}) {
    return FlutterBluePlus.adapterState.listen((state) {
        adapterState = state;
        doSomething!();
      });
  }

  static StreamSubscription<List<ScanResult>> scanResultsSubscription ({void Function()? doSomething, void Function(Exception)? error}) {
    return FlutterBluePlus.scanResults.listen((results) {
      scanResults = results;
      scanResultsDevicesRepository.addAll(results.map((item) => MyBluetoothDeviceRepository(item.device)));
      doSomething!();
    }, onError: (e) {
      error!(e);
    });
  }

  static StreamSubscription<bool> isScanningSubscription ({void Function()? doSomething}) {
    return FlutterBluePlus.isScanning.listen((state) {
      doSomething!();
    });
  }

  static scanOn() async {
    if(isScanning) {
      return;
    }
    try {
      systemDevicesRepository = (await FlutterBluePlus.systemDevices).map((item) => MyBluetoothDeviceRepository(item)).toList();
      // android is slow when asking for all advertisements,
      // so instead we only ask for 1/8 of them
      int divisor = Platform.isAndroid ? 8 : 1;
      await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 15),
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

}