import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothDvState extends Equatable {
  const BluetoothDvState();

  @override
  List<Object?> get props => [];
}

class BluetoothDvErrorState extends BluetoothDvState {
  Object exception;

  BluetoothDvErrorState(this.exception);

  @override
  List<Object?> get props => [exception];

  @override
  String toString() {
    return 'BluetoothDvErrorState: $exception';
  }
}

class BluetoothDvStateInit extends BluetoothDvState {
  @override
  String toString() {
    return 'BluetoothDvStateInit';
  }
}

class BluetoothDvStateRefreshing extends BluetoothDvState {
  @override
  String toString() {
    return 'BluetoothDvStateRefreshing';
  }
}

class BluetoothDvStateDispose extends BluetoothDvState {
  @override
  String toString() {
    return 'BluetoothDvStateDispose';
  }
}