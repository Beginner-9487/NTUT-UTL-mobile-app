import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../../entity/user_entity.dart';

abstract class BluetoothPageEvent extends Equatable {
  const BluetoothPageEvent();

  @override
  List<Object?> get props => [];
}

class InitBluetooth extends BluetoothPageEvent {
  @override
  String toString() {
    return 'InitBluetooth';
  }
}

class TurnOnBluetooth extends BluetoothPageEvent {
  @override
  String toString() {
    return 'TurnOnBluetooth';
  }
}

class TurnOffBluetooth extends BluetoothPageEvent {
  @override
  String toString() {
    return 'TurnOffBluetooth';
  }
}

class ScanOnBluetooth extends BluetoothPageEvent {
  @override
  String toString() {
    return 'ScanOnBluetooth';
  }
}

class ScanOffBluetooth extends BluetoothPageEvent {
  @override
  String toString() {
    return 'ScanOffBluetooth';
  }
}

class ConnectDeviceBluetooth extends BluetoothPageEvent {
  BluetoothDevice device;

  ConnectDeviceBluetooth(this.device);

  @override
  List<Object?> get props => [device];

  @override
  String toString() {
    return 'ScanOffBluetooth: $device';
  }
}

class DisconnectDeviceBluetooth extends BluetoothPageEvent {
  BluetoothDevice device;

  DisconnectDeviceBluetooth(this.device);

  @override
  List<Object?> get props => [device];

  @override
  String toString() {
    return 'ScanOffBluetooth: $device';
  }
}

class SendCommandDeviceBluetooth extends BluetoothPageEvent {
  BluetoothDevice device;
  List<int> value;

  SendCommandDeviceBluetooth(this.device, this.value);

  @override
  List<Object?> get props => [device, value];

  @override
  String toString() {
    return 'ScanOffBluetooth: $device: $value';
  }
}

class DisposeBluetooth extends BluetoothPageEvent {
  @override
  String toString() {
    return 'InitBluetooth';
  }
}