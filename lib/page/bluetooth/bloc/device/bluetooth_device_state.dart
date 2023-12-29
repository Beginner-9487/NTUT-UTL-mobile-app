import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothDevicePageState extends Equatable {
  const BluetoothDevicePageState();

  @override
  List<Object?> get props => [];
}

class BluetoothDeviceErrorState extends BluetoothDevicePageState {
  Object exception;

  BluetoothDeviceErrorState(this.exception);

  @override
  List<Object?> get props => [exception];

  @override
  String toString() {
    return 'BluetoothDeviceErrorState';
  }
}

class InitiatingDeviceBluetoothDeviceState extends BluetoothDevicePageState {
  BluetoothDevice? device;

  InitiatingDeviceBluetoothDeviceState(this.device);

  @override
  List<Object?> get props => [device];

  @override
  String toString() {
    return 'InitiatingDeviceBluetoothDeviceState: ${device?.advName}';
  }
}

class ConnectionDeviceBluetoothDeviceState extends BluetoothDevicePageState {
  BluetoothConnectionState currentConnectionState;

  ConnectionDeviceBluetoothDeviceState(this.currentConnectionState);

  @override
  List<Object?> get props => [currentConnectionState];

  @override
  String toString() {
    return 'ConnectionDeviceBluetoothDeviceState: $currentConnectionState';
  }
}

class MtuSizeDeviceBluetoothDeviceState extends BluetoothDevicePageState {
  int mtuSize;

  MtuSizeDeviceBluetoothDeviceState(this.mtuSize);

  @override
  List<Object?> get props => [mtuSize];

  @override
  String toString() {
    return 'MtuSizeDeviceBluetoothDeviceState: $mtuSize';
  }
}

class IsConnectingBluetoothDeviceState extends BluetoothDevicePageState {
  bool isConnecting;

  IsConnectingBluetoothDeviceState(this.isConnecting);

  @override
  List<Object?> get props => [isConnecting];

  @override
  String toString() {
    return 'IsConnectingBluetoothDeviceState: $isConnecting';
  }
}

class IsDisconnectingBluetoothState extends BluetoothDevicePageState {
  bool isDisconnecting;

  IsDisconnectingBluetoothState(this.isDisconnecting);

  @override
  List<Object?> get props => [isDisconnecting];

  @override
  String toString() {
    return 'IsDisconnectingBluetoothState: $isDisconnecting';
  }
}

class DiscoverServicesBluetoothDeviceState extends BluetoothDevicePageState {
  List<BluetoothService> services;
  bool isDiscoveringServices;

  DiscoverServicesBluetoothDeviceState(this.services, this.isDiscoveringServices);

  @override
  List<Object?> get props => [services, isDiscoveringServices];

  @override
  String toString() {
    return 'DiscoverServicesBluetoothDeviceState: $isDiscoveringServices';
  }
}

class RequestMtuBluetoothDeviceState extends BluetoothDevicePageState {
  int mtuSize;

  RequestMtuBluetoothDeviceState(this.mtuSize);

  @override
  List<Object?> get props => [mtuSize];

  @override
  String toString() {
    return 'RequestMtuBluetoothDeviceState: $mtuSize';
  }
}

class DisposedBluetoothDeviceState extends BluetoothDevicePageState {
  @override
  String toString() {
    return 'DisposedBluetoothDeviceState';
  }
}