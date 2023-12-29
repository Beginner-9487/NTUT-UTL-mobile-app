import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothChaDesPageState extends Equatable {
  const BluetoothChaDesPageState();

  @override
  List<Object?> get props => [];
}

class InitState extends BluetoothChaDesPageState {
  @override
  String toString() {
    return 'InitState';
  }
}

class ErrorState extends BluetoothChaDesPageState {
  Object exception;

  ErrorState(this.exception);

  @override
  List<Object?> get props => [exception];

  @override
  String toString() {
    return 'ErrorEvent: $exception';
  }
}

class ReceiveValueState extends BluetoothChaDesPageState {
  BluetoothCharacteristic? characteristic;
  BluetoothDescriptor? descriptor;
  List<int> value;

  ReceiveValueState(this.characteristic, this.descriptor, this.value);

  @override
  List<Object?> get props => [characteristic, descriptor, value];

  @override
  String toString() {
    return 'ReceiveValueState: ${characteristic!.characteristicUuid} - ${descriptor!.characteristicUuid}: $value';
  }
}

class ReadValueState extends BluetoothChaDesPageState {
  BluetoothCharacteristic? characteristic;
  BluetoothDescriptor? descriptor;
  List<int> value;

  ReadValueState(this.characteristic, this.descriptor, this.value);

  @override
  List<Object?> get props => [characteristic, descriptor, value];

  @override
  String toString() {
    return 'ReadValueChaState: ${characteristic!.characteristicUuid} - ${descriptor!.characteristicUuid}: $value';
  }
}

class WriteValueState extends BluetoothChaDesPageState {
  BluetoothCharacteristic? characteristic;
  BluetoothDescriptor? descriptor;
  List<int> value;

  WriteValueState(this.characteristic, this.descriptor, this.value);

  @override
  List<Object?> get props => [characteristic, descriptor, value];

  @override
  String toString() {
    return 'WriteValueState: ${characteristic!.characteristicUuid} - ${descriptor!.characteristicUuid}: $value';
  }
}

class SubscribingState extends BluetoothChaDesPageState {
  BluetoothCharacteristic? characteristic;
  BluetoothDescriptor? descriptor;
  bool isNotifying;

  SubscribingState(this.characteristic, this.descriptor, this.isNotifying);

  @override
  List<Object?> get props => [characteristic, descriptor, isNotifying];

  @override
  String toString() {
    return 'SubscribingState: ${characteristic!.characteristicUuid} - ${descriptor!.characteristicUuid}: $isNotifying';
  }
}

class DisposedState extends BluetoothChaDesPageState {
  @override
  String toString() {
    return 'DisposedState';
  }
}