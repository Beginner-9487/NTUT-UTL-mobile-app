import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/page/bluetooth/utils/extra.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/my_bluetooth_repository.dart';

import 'bluetooth_event.dart';
import 'bluetooth_state.dart';

class BluetoothPageBloc extends Bloc<BluetoothPageEvent, BluetoothPageState> {

  static BluetoothAdapterState get adapterState => MyBluetoothRepository.adapterState;
  static List<ScanResult> get scanResults => MyBluetoothRepository.scanResults;
  static bool get isScanning => MyBluetoothRepository.isScanning;

  static late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
  static late StreamSubscription<bool> _isScanningSubscription;
  static late StreamSubscription<List<ScanResult>> _scanResultsSubscription;

  @override
  static BluetoothPageState get initialState => BluetoothInitiatingState();

  void registerEvent() {
    on<InitBluetooth>((event, emit) {
      mapEventToState(event).first;
    });
    on<TurnOnBluetooth>((event, emit) {
      mapEventToState(event).first;
    });
    on<TurnOffBluetooth>((event, emit) {
      mapEventToState(event).first;
    });
    on<ScanOnBluetooth>((event, emit) {
      mapEventToState(event).first;
    });
    on<ScanOffBluetooth>((event, emit) {
      mapEventToState(event).first;
    });
    on<ConnectDeviceBluetooth>((event, emit) {
      mapEventToState(event).first;
    });
    on<DisconnectDeviceBluetooth>((event, emit) {
      mapEventToState(event).first;
    });
    on<DisposeBluetooth>((event, emit) {
      mapEventToState(event).first;
    });
  }

  BluetoothPageBloc() : super(initialState) {
    _adapterStateStateSubscription = MyBluetoothRepository.bluetoothAdapterListen(doSomething: () {
      emit(BluetoothAdapterStatingState(adapterState));
    });

    _isScanningSubscription = MyBluetoothRepository.isScanningSubscription(doSomething: () {
      emit(BluetoothIsScanningState(isScanning));
    });

    _scanResultsSubscription = MyBluetoothRepository.scanResultsSubscription(
        doSomething: () {
          emit(BluetoothScanningResultsState(scanResults));
        },
        error: (Exception exception) {
          emit(BluetoothPageErrorState(exception));
        }
    );
    registerEvent();
  }

  @override
  Stream<BluetoothPageState> mapEventToState(BluetoothPageEvent event) async* {
    print("BluetoothBloc: mapEventToState: $event");
    try {
      if (event is InitBluetooth) {
        yield* _mapInitBluetoothToState();
      } else if (event is TurnOnBluetooth) {
        yield* _mapTurnOnBluetoothToState();
      } else if (event is ScanOnBluetooth) {
        yield* _mapScanOnBluetoothToState();
      } else if (event is ScanOffBluetooth) {
        yield* _mapScanOffBluetoothToState();
      } else if (event is ConnectDeviceBluetooth) {
        yield* _mapConnectDeviceBluetoothToState(event.device);
      } else if (event is DisconnectDeviceBluetooth) {
        yield* _mapDisconnectDeviceBluetoothToState(event.device);
      } else if (event is DisposeBluetooth) {
        yield* _mapDisposeBluetoothToState();
      }
    } catch (e) {
      emit(BluetoothPageErrorState(e));
    }
  }

  Stream<BluetoothPageState> _mapInitBluetoothToState() async* {
    _adapterStateStateSubscription;
    emit(BluetoothAdapterStatingState(adapterState));
  }

  Stream<BluetoothPageState> _mapTurnOnBluetoothToState() async* {
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
    emit(BluetoothAdapterStatingState(adapterState));
  }

  Stream<BluetoothPageState> _mapScanOnBluetoothToState() async* {
    // _adapterStateStateSubscription?.cancel();
    // _isScanningSubscription?.cancel();
    // _scanResultsSubscription?.cancel();
    MyBluetoothRepository.scanOn();
    emit(BluetoothIsScanningState(isScanning));
  }

  Stream<BluetoothPageState> _mapScanOffBluetoothToState() async* {
    MyBluetoothRepository.scanOff();
    // _adapterStateStateSubscription.cancel();
    // _isScanningSubscription.cancel();
    // _scanResultsSubscription.cancel();
    emit(BluetoothIsScanningState(isScanning));
  }

  onConnectDevice(BluetoothDevice device) {}
  Stream<BluetoothPageState> _mapConnectDeviceBluetoothToState(BluetoothDevice device) async* {
    emit(BluetoothConnectingDevicesState(device));
    device.connectAndUpdateStream().catchError((e) {
      emit(BluetoothPageErrorState(e));
    });
    onConnectDevice(device);
    emit(BluetoothConnectedDevicesState(MyBluetoothRepository.connectedDevices));
  }

  onDisconnectDevice(BluetoothDevice device) {}
  Stream<BluetoothPageState> _mapDisconnectDeviceBluetoothToState(BluetoothDevice device) async* {
    emit(BluetoothDisconnectingDevicesState(device));
    device.disconnect().catchError((e) {
      emit(BluetoothPageErrorState(e));
    });
    onDisconnectDevice(device);
    emit(BluetoothDisconnectedDevicesState(MyBluetoothRepository.connectedDevices));
  }

  Stream<BluetoothPageState> _mapDisposeBluetoothToState() async* {
    _adapterStateStateSubscription.cancel();
    _isScanningSubscription.cancel();
    _scanResultsSubscription.cancel();
    emit(BluetoothDisposedState());
  }
}
