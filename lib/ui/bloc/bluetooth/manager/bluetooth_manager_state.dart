import 'package:equatable/equatable.dart';

abstract class BluetoothManagerState extends Equatable {
  const BluetoothManagerState();

  @override
  List<Object?> get props => [];
}

class BluetoothManagerStateError extends BluetoothManagerState {
  Exception exception;

  BluetoothManagerStateError(this.exception);

  @override
  List<Exception?> get props => [exception];

  @override
  String toString() {
    return 'BluetoothManagerStateError: $exception';
  }
}

class BluetoothManagerStateInit extends BluetoothManagerState {
  @override
  String toString() {
    return 'BluetoothManagerStateInit';
  }
}

class BluetoothManagerStateRefreshing extends BluetoothManagerState {
  @override
  String toString() {
    return 'BluetoothManagerStateRefreshing';
  }
}

class BluetoothManagerStateDispose extends BluetoothManagerState {
  @override
  String toString() {
    return 'BluetoothManagerStateDispose';
  }
}