import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothDevicePageEvent extends Equatable {
  const BluetoothDevicePageEvent();

  @override
  List<Object?> get props => [];
}

class InitBluetoothDeviceEvent extends BluetoothDevicePageEvent {
  BluetoothDevice device;

  InitBluetoothDeviceEvent(this.device);

  @override
  List<Object?> get props => [device];

  @override
  String toString() {
    return 'InitBluetoothDeviceEvent: ${device.advName}';
  }
}

class ConnectBluetoothDeviceEvent extends BluetoothDevicePageEvent {
  @override
  String toString() {
    return 'ConnectBluetoothDeviceEvent';
  }
}

class CancelBluetoothDeviceEvent extends BluetoothDevicePageEvent {
  @override
  String toString() {
    return 'CancelBluetoothDeviceEvent';
  }
}

class DisconnectBluetoothDeviceEvent extends BluetoothDevicePageEvent {
  @override
  String toString() {
    return 'DisconnectBluetoothDeviceEvent';
  }
}

class DiscoverServicesBluetoothDeviceEvent extends BluetoothDevicePageEvent {
  @override
  String toString() {
    return 'DiscoverServicesBluetoothDeviceEvent';
  }
}

class RequestMtuBluetoothDeviceEvent extends BluetoothDevicePageEvent {
  @override
  String toString() {
    return 'RequestMtuBluetoothDeviceEvent';
  }
}

class DisposeBluetoothDeviceEvent extends BluetoothDevicePageEvent {
  @override
  String toString() {
    return 'DisposeBluetoothDeviceEvent';
  }
}