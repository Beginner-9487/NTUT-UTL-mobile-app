import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';

abstract class BluetoothManagerEvent extends Equatable {
  const BluetoothManagerEvent();

  @override
  List<Object?> get props => [];
}

class BluetoothManagerEventInit extends BluetoothManagerEvent {
  @override
  String toString() {
    return 'BluetoothManagerEventInit';
  }
}

class BluetoothManagerEventTurnOn extends BluetoothManagerEvent {
  @override
  String toString() {
    return 'BluetoothManagerEventTurnOn';
  }
}

class BluetoothManagerEventTurnOff extends BluetoothManagerEvent {
  @override
  String toString() {
    return 'BluetoothManagerEventTurnOff';
  }
}

class BluetoothManagerEventScanOn extends BluetoothManagerEvent {
  @override
  String toString() {
    return 'BluetoothManagerEventScanOn';
  }
}

class BluetoothManagerEventScanOff extends BluetoothManagerEvent {
  @override
  String toString() {
    return 'BluetoothManagerEventScanOff';
  }
}

class BluetoothManagerEventConnectDevice extends BluetoothManagerEvent {
  BLEDevice device;

  BluetoothManagerEventConnectDevice(this.device);

  @override
  List<Object?> get props => [device];

  @override
  String toString() {
    return 'BluetoothManagerEventConnectDevice: $device';
  }
}

class BluetoothManagerEventDisconnectDevice extends BluetoothManagerEvent {
  BLEDevice device;

  BluetoothManagerEventDisconnectDevice(this.device);

  @override
  List<Object?> get props => [device];

  @override
  String toString() {
    return 'BluetoothManagerEventDisconnectDevice: $device';
  }
}

class SendCommandDeviceBluetooth extends BluetoothManagerEvent {
  BluetoothDevice device;
  List<int> value;

  SendCommandDeviceBluetooth(this.device, this.value);

  @override
  List<Object?> get props => [device, value];

  @override
  String toString() {
    return 'SendCommandDeviceBluetooth: $device: $value';
  }
}

class BluetoothManagerEventDispose extends BluetoothManagerEvent {
  @override
  String toString() {
    return 'BluetoothManagerEventDispose';
  }
}