import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothDvEvent extends Equatable {
  const BluetoothDvEvent();

  @override
  List<Object?> get props => [];
}

class BluetoothDvEventInit extends BluetoothDvEvent {
  BluetoothDevice device;

  BluetoothDvEventInit(this.device);

  @override
  List<Object?> get props => [device];

  @override
  String toString() {
    return 'BluetoothDvEventInit: ${device.advName}';
  }
}

class BluetoothDvEventConnect extends BluetoothDvEvent {
  @override
  String toString() {
    return 'BluetoothDvEventConnect';
  }
}

class BluetoothDvEventDisconnect extends BluetoothDvEvent {
  @override
  String toString() {
    return 'BluetoothDvEventDisconnect';
  }
}

class BluetoothDvEventDiscoverServices extends BluetoothDvEvent {
  @override
  String toString() {
    return 'BluetoothDvEventDiscoverServices';
  }
}

class BluetoothDvEventDispose extends BluetoothDvEvent {
  @override
  String toString() {
    return 'BluetoothDvEventDispose';
  }
}