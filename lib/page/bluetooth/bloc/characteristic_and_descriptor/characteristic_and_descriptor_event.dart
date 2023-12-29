import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothChaDesPageEvent extends Equatable {
  const BluetoothChaDesPageEvent();

  @override
  List<Object?> get props => [];
}

class ReadValueEvent extends BluetoothChaDesPageEvent {
  @override
  String toString() {
    return 'ReadValueEvent';
  }
}

class WriteValueEvent extends BluetoothChaDesPageEvent {
  Uint8List value;

  WriteValueEvent(this.value);

  @override
  List<Object?> get props => [value];

  @override
  String toString() {
    return 'WriteValueEvent: $value';
  }
}

class ChangeSubscribeEvent extends BluetoothChaDesPageEvent {
  @override
  String toString() {
    return 'ChangeSubscribeEvent';
  }
}

class SetSubscribeEvent extends BluetoothChaDesPageEvent {
  bool isNotify;

  SetSubscribeEvent(this.isNotify);

  @override
  List<Object?> get props => [isNotify];

  @override
  String toString() {
    return 'SetSubscribeEvent: $isNotify';
  }
}

class DisposeEvent extends BluetoothChaDesPageEvent {
  @override
  String toString() {
    return 'DisposeEvent';
  }
}