import 'package:equatable/equatable.dart';

abstract class BluetoothSwitchState extends Equatable {
  const BluetoothSwitchState();

  @override
  List<Object?> get props => [];
}

class BluetoothSwitchStateError extends BluetoothSwitchState {
  Exception exception;

  BluetoothSwitchStateError(this.exception);

  @override
  List<Exception?> get props => [exception];

  @override
  String toString() {
    return 'BluetoothSwitchStateError: $exception';
  }
}

class BluetoothSwitchStateInit extends BluetoothSwitchState {
  @override
  String toString() {
    return 'BluetoothSwitchStateInit';
  }
}

class BluetoothSwitchStateRefreshing extends BluetoothSwitchState {
  @override
  String toString() {
    return 'BluetoothSwitchStateRefreshing';
  }
}

class BluetoothSwitchStateTurn extends BluetoothSwitchState {
  bool state;

  BluetoothSwitchStateTurn(this.state);

  @override
  List<Object?> get props => [state];

  @override
  String toString() {
    return 'BluetoothSwitchStateTurn: $state';
  }
}

class BluetoothSwitchStateDispose extends BluetoothSwitchState {
  @override
  String toString() {
    return 'BluetoothSwitchStateDispose';
  }
}