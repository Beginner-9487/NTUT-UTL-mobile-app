import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';

import 'bluetooth_device_event.dart';
import 'bluetooth_device_state.dart';

class BluetoothDvBloc extends Bloc<BluetoothDvEvent, BluetoothDvState> {

  BLEDevice device;
  int get mtuSize => device.mtuSize;
  bool get isConnected => device.isConnected;
  bool get isConnecting => device.isConnecting;
  bool get isDisconnecting => device.isDisconnecting;
  bool get connectable => device.connectable;

  late StreamSubscription<int> _mtuSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;
  late StreamSubscription<bool> _isDiscoveringServicesStateSubscription;

  @override
  static BluetoothDvState get initialState => BluetoothDvStateInit();

  void registerSubscription() {
    _mtuSubscription = device.onRequestMtuSubscription((int mtu) {
      _refreshUI();
    });

    _isConnectingSubscription = device.onConnectingSubscription((bool state) {
      _refreshUI();
    });

    _isDisconnectingSubscription = device.onDisconnectingSubscription((bool state) {
      _refreshUI();
    });

    _isDiscoveringServicesStateSubscription = device.onDiscoveringServicesStateSubscription((bool state) {
      _refreshUI();
    });
  }

  void registerEvent() {
    on<BluetoothDvEventInit>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothDvEventConnect>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothDvEventDisconnect>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothDvEventDiscoverServices>((event, emit) {
      mapEventToState(event).first;
    });
    on<BluetoothDvEventDispose>((event, emit) {
      mapEventToState(event).first;
    });
  }

  BluetoothDvBloc(this.device) : super(initialState) {
    registerSubscription();
    registerEvent();
  }

  @override
  Stream<BluetoothDvEvent> mapEventToState(BluetoothDvEvent event) async* {
    debugPrint("BluetoothDvEvent: mapEventToState: $event");
    try {
      if (event is BluetoothDvEventInit) {
        yield* _mapInitToState();
      } else if (event is BluetoothDvEventConnect) {
        yield* _mapConnectToState();
      } else if (event is BluetoothDvEventDisconnect) {
        yield* _mapDisconnectToState();
      } else if (event is BluetoothDvEventDiscoverServices) {
        yield* _mapDiscoverServicesToState();
      } else if (event is BluetoothDvEventDispose) {
        yield* _mapDisposeToState();
      }
    } catch (e) {
      emit(BluetoothDvErrorState(e));
    }
  }

  _refreshUI() {
    emit(BluetoothDvStateRefreshing());
    emit(BluetoothDvStateInit());
  }

  Stream<BluetoothDvEvent> _mapInitToState() async* {
    _refreshUI();
  }

  Stream<BluetoothDvEvent> _mapConnectToState() async* {
    device.connect();
    _refreshUI();
  }

  Stream<BluetoothDvEvent> _mapDisconnectToState() async* {
    device.disconnect();
    _refreshUI();
  }

  Stream<BluetoothDvEvent> _mapDiscoverServicesToState() async* {
    device.discoverServices();
    _refreshUI();
  }

  Stream<BluetoothDvEvent> _mapDisposeToState() async* {
    _mtuSubscription.cancel();
    _isConnectingSubscription.cancel();
    _isDisconnectingSubscription.cancel();
    _isDiscoveringServicesStateSubscription.cancel();
    _refreshUI();
  }
}
