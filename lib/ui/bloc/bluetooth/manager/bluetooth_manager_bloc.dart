import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_concrete_flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import 'bluetooth_manager_event.dart';
import 'bluetooth_manager_state.dart';

class BluetoothManagerBloc extends Bloc<BluetoothManagerEvent, BluetoothManagerState> {

  BLEManager get bleManager => ProjectParameters.bleManager;

  bool get isBluetoothOn => bleManager.isBluetoothOn;
  bool get isScanning => bleManager.isScanning;
  List get devices => bleManager.devices;

  late StreamSubscription<bool> _isBluetoothOnSubscription;
  late bool _isBluetoothOnSubscriptionBuffer = isBluetoothOn;
  late StreamSubscription<bool> _isScanningSubscription;
  late bool _isScanningSubscriptionBuffer = isScanning;
  late StreamSubscription<List> _scanResultsSubscription;
  late int _scanResultsSubscriptionBuffer = devices.length;

  @override
  static BluetoothManagerState get initialState => BluetoothManagerStateInit();

  void registerSubscription() {
    _isBluetoothOnSubscription = bleManager.onBluetoothStateChangeSubscription((bool state) {
      // debugPrint("BBB: $state");
      if(_isBluetoothOnSubscriptionBuffer != state) {
        _refreshUI();
        _isBluetoothOnSubscriptionBuffer = state;
      }
    });

    _isScanningSubscription = bleManager.onScanningStateChangeSubscription((bool state) {
      // debugPrint("SSS: $state");
      if(_isScanningSubscriptionBuffer != state) {
        _refreshUI();
        _isScanningSubscriptionBuffer = state;
      }
    });

    _scanResultsSubscription = bleManager.onNewDeviceFoundSubscription((List results) {
      // debugPrint("RRR: ${results.length}");
      if(_scanResultsSubscriptionBuffer != results.length) {
        _refreshUI();
        _scanResultsSubscriptionBuffer = results.length;
      }
    });
  }

  void registerEvent() {
    on<BluetoothManagerEventInit>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothManagerEventTurnOn>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothManagerEventTurnOff>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothManagerEventScanOn>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothManagerEventScanOff>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothManagerEventConnectDevice>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothManagerEventDisconnectDevice>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothManagerEventDispose>((event, emit) {
      mapEventToState(event).first;
    });
  }

  BluetoothManagerBloc() : super(initialState) {
    debugPrint("BluetoothManagerBloc - initialState: $initialState");
    registerSubscription();
    registerEvent();
  }

  @override
  Stream<BluetoothManagerState> mapEventToState(BluetoothManagerEvent event) async* {
    debugPrint("BluetoothManagerBloc: mapEventToState: $event");
    try {
      if (event is BluetoothManagerEventInit) {
        yield* _mapInitToState();
      } else if (event is BluetoothManagerEventTurnOn) {
        yield* _mapTurnOnToState();
      } else if (event is BluetoothManagerEventTurnOff) {
        yield* _mapTurnOffToState();
      } else if (event is BluetoothManagerEventScanOn) {
        yield* _mapScanOnToState();
      } else if (event is BluetoothManagerEventScanOff) {
        yield* _mapScanOffToState();
      } else if (event is BluetoothManagerEventConnectDevice) {
        yield* _mapConnectDeviceToState(event.device);
      } else if (event is BluetoothManagerEventDisconnectDevice) {
        yield* _mapDisconnectDeviceToState(event.device);
      } else if (event is BluetoothManagerEventDispose) {
        yield* _mapDisposeToState();
      }
    } catch (e) {
      emit(BluetoothManagerStateError(e as Exception));
    }
  }

  _refreshUI() {
    emit(BluetoothManagerStateRefreshing());
    emit(BluetoothManagerStateInit());
  }

  Stream<BluetoothManagerState> _mapInitToState() async* {
    _refreshUI();
  }

  Stream<BluetoothManagerState> _mapTurnOnToState() async* {
    bleManager.turnOn();
    _refreshUI();
  }

  Stream<BluetoothManagerState> _mapTurnOffToState() async* {
    bleManager.turnOff();
    _refreshUI();
  }

  Stream<BluetoothManagerState> _mapScanOnToState() async* {
    bleManager.scanOn();
    _refreshUI();
  }

  Stream<BluetoothManagerState> _mapScanOffToState() async* {
    bleManager.scanOff();
    _refreshUI();
  }

  onConnectDevice(BLEDevice device) {}
  Stream<BluetoothManagerState> _mapConnectDeviceToState(BLEDevice device) async* {
    device.connect();
    onConnectDevice(device);
    _refreshUI();
  }

  onDisconnectDevice(BLEDevice device) {}
  Stream<BluetoothManagerState> _mapDisconnectDeviceToState(BLEDevice device) async* {
    device.disconnect();
    onDisconnectDevice(device);
    _refreshUI();
  }

  Stream<BluetoothManagerState> _mapDisposeToState() async* {
    _isBluetoothOnSubscription.cancel();
    _isScanningSubscription.cancel();
    _scanResultsSubscription.cancel();
    _refreshUI();
  }
}
