import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../../repository/bluetooth/my_bluetooth_device_repository.dart';

abstract class BluetoothPageState extends Equatable {
  const BluetoothPageState();

  @override
  List<Object?> get props => [];
}

class BluetoothPageErrorState extends BluetoothPageState {
  Object exception;

  BluetoothPageErrorState(this.exception);

  @override
  List<Object?> get props => [exception];

  @override
  String toString() {
    return 'BluetoothError';
  }
}

class BluetoothInitiatingState extends BluetoothPageState {
  @override
  String toString() {
    return 'InitiatingBluetooth';
  }
}

class BluetoothInitiatedState extends BluetoothPageState {

  StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  BluetoothInitiatedState(this._adapterStateStateSubscription);

  @override
  List<Object?> get props => [_adapterStateStateSubscription];

  @override
  String toString() {
    return 'InitiatedBluetooth: $_adapterStateStateSubscription';
  }
}

class BluetoothAdapterStatingState extends BluetoothPageState {
  BluetoothAdapterState adapterState;

  BluetoothAdapterStatingState(this.adapterState);

  @override
  List<Object?> get props => [adapterState];

  @override
  String toString() {
    return 'BluetoothAdapterStating{adapterState: $adapterState';
  }
}

class BluetoothIsScanningState extends BluetoothPageState {
  bool isScanning;

  BluetoothIsScanningState(this.isScanning);

  @override
  List<Object?> get props => [isScanning];

  @override
  String toString() {
    return 'BluetoothIsScanning{isScanning: $isScanning';
  }
}

class BluetoothScanningResultsState extends BluetoothPageState {
  List<ScanResult> scanResults;

  BluetoothScanningResultsState(this.scanResults);

  @override
  List<Object?> get props => [scanResults];

  @override
  String toString() {
    return 'BluetoothScanningResults{scanResults: ${scanResults.length}';
  }
}

class BluetoothConnectingDevicesState extends BluetoothPageState {
  BluetoothDevice device;

  BluetoothConnectingDevicesState(this.device);

  @override
  List<Object?> get props => [device];

  @override
  String toString() {
    return 'BluetoothConnectingDevicesState: $device';
  }
}

class BluetoothDisconnectingDevicesState extends BluetoothPageState {
  BluetoothDevice device;

  BluetoothDisconnectingDevicesState(this.device);

  @override
  List<Object?> get props => [device];

  @override
  String toString() {
    return 'BluetoothDisconnectingDevicesState: $device';
  }
}

class BluetoothConnectedDevicesState extends BluetoothPageState {
  List<BluetoothDevice> devices;

  BluetoothConnectedDevicesState(this.devices);

  @override
  List<Object?> get props => [devices];

  @override
  String toString() {
    return 'BluetoothConnectedDevicesState: ${devices.length}';
  }
}

class BluetoothDisconnectedDevicesState extends BluetoothPageState {
  List<BluetoothDevice> devices;

  BluetoothDisconnectedDevicesState(this.devices);

  @override
  List<Object?> get props => [devices];

  @override
  String toString() {
    return 'BluetoothDisconnectedDevicesState: ${devices.length}';
  }
}

class SendCommandDeviceBluetoothState extends BluetoothPageState {
  BluetoothDevice devices;
  List<int> value;

  SendCommandDeviceBluetoothState(this.devices, this.value);

  @override
  List<Object?> get props => [devices, value];

  @override
  String toString() {
    return 'SendCommandDeviceBluetoothState: $devices: $value';
  }
}

class BluetoothDisposedState extends BluetoothPageState {
  @override
  String toString() {
    return 'BluetoothDisposedState';
  }
}