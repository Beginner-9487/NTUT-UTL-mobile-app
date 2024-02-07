import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import 'bluetooth_switch_event.dart';
import 'bluetooth_switch_state.dart';

class BluetoothSwitchBloc extends Bloc<BluetoothSwitchEvent, BluetoothSwitchState> {

  BLEManager get bleSwitch => ProjectParameters.bleManager;

  bool get isBluetoothOn => bleSwitch.isBluetoothOn;

  late StreamSubscription<bool> _isBluetoothOnSubscription;
  late bool _isBluetoothOnSubscriptionBuffer = false;

  @override
  static BluetoothSwitchState get initialState => BluetoothSwitchStateInit();

  void registerSubscription() {
    _isBluetoothOnSubscription = bleSwitch.onBluetoothStateChangeSubscription((bool state) {
      if(_isBluetoothOnSubscriptionBuffer != state) {
        emit(BluetoothSwitchStateTurn(state));
        _isBluetoothOnSubscriptionBuffer = state;
      }
    });
  }

  void registerEvent() {
    on<BluetoothSwitchEventInit>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothSwitchEventTurnOn>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothSwitchEventTurnOff>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothSwitchEventDispose>((event, emit) {
      mapEventToState(event).first;
    });
  }

  BluetoothSwitchBloc() : super(initialState) {
    debugPrint("BluetoothSwitchBloc - initialState: $initialState");
    registerSubscription();
    registerEvent();
  }

  @override
  Stream<BluetoothSwitchState> mapEventToState(BluetoothSwitchEvent event) async* {
    debugPrint("BluetoothUIBloc: mapEventToState: $event");
    try {
      if (event is BluetoothSwitchEventInit) {
        yield* _mapInitToState();
      } else if (event is BluetoothSwitchEventTurnOn) {
        yield* _mapTurnOnToState();
      } else if (event is BluetoothSwitchEventTurnOff) {
        yield* _mapTurnOffToState();
      } else if (event is BluetoothSwitchEventDispose) {
        yield* _mapDisposeToState();
      }
    } catch (e) {
      emit(BluetoothSwitchStateError(e as Exception));
    }
  }

  _refreshUI() {
    emit(BluetoothSwitchStateRefreshing());
    emit(BluetoothSwitchStateInit());
  }

  Stream<BluetoothSwitchState> _mapInitToState() async* {
    _refreshUI();
  }

  Stream<BluetoothSwitchState> _mapTurnOnToState() async* {
    bleSwitch.turnOn();
    _refreshUI();
  }

  Stream<BluetoothSwitchState> _mapTurnOffToState() async* {
    bleSwitch.turnOff();
    _refreshUI();
  }

  Stream<BluetoothSwitchState> _mapDisposeToState() async* {
    _isBluetoothOnSubscription.cancel();
    _refreshUI();
  }
}
