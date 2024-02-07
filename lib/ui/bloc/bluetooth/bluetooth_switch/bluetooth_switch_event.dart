import 'package:equatable/equatable.dart';

abstract class BluetoothSwitchEvent extends Equatable {
  const BluetoothSwitchEvent();

  @override
  List<Object?> get props => [];
}

class BluetoothSwitchEventInit extends BluetoothSwitchEvent {
  @override
  String toString() {
    return 'BluetoothSwitchEventInit';
  }
}

class BluetoothSwitchEventTurnOn extends BluetoothSwitchEvent {
  @override
  String toString() {
    return 'BluetoothSwitchEventTurnOn';
  }
}

class BluetoothSwitchEventTurnOff extends BluetoothSwitchEvent {
  @override
  String toString() {
    return 'BluetoothSwitchEventTurnOff';
  }
}

class BluetoothSwitchEventDispose extends BluetoothSwitchEvent {
  @override
  String toString() {
    return 'BluetoothSwitchEventDispose';
  }
}