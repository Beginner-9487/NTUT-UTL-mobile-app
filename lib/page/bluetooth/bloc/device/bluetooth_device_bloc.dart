import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/my_bluetooth_device_repository.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/my_bluetooth_repository.dart';

import 'bluetooth_device_event.dart';
import 'bluetooth_device_state.dart';

class BluetoothDevicePageBloc extends Bloc<BluetoothDevicePageEvent, BluetoothDevicePageState> {

  late MyBluetoothDeviceRepository device;
  BluetoothConnectionState get currentConnectionState => device.currentConnectionState;
  int get mtuSize => device.mtuSize;
  bool get isConnecting => device.isConnecting;
  bool get isDisconnecting => device.isDisconnecting;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;
  late StreamSubscription<int> _mtuSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;

  @override
  static BluetoothDevicePageState get initialState => InitiatingDeviceBluetoothDeviceState(null);

  BluetoothDevicePageBloc(BluetoothDevice bluetoothDevice) : super(initialState) {

    device = MyBluetoothDeviceRepository(bluetoothDevice);

    on<InitBluetoothDeviceEvent>((event, emit) {
      mapEventToState(event).first;
    });
    on<ConnectBluetoothDeviceEvent>((event, emit) {
      mapEventToState(event).first;
    });
    on<CancelBluetoothDeviceEvent>((event, emit) {
      mapEventToState(event).first;
    });
    on<DisconnectBluetoothDeviceEvent>((event, emit) {
      mapEventToState(event).first;
    });
    on<DiscoverServicesBluetoothDeviceEvent>((event, emit) {
      mapEventToState(event).first;
    });
    on<RequestMtuBluetoothDeviceEvent>((event, emit) {
      mapEventToState(event).first;
    });
  }

  @override
  Stream<BluetoothDevicePageEvent> mapEventToState(BluetoothDevicePageEvent event) async* {
    print("BluetoothDeviceBloc: mapEventToState: $event");
    try {
      if (event is InitBluetoothDeviceEvent) {
        yield* _mapInitBluetoothDeviceToState(event.device);
      } else if (event is ConnectBluetoothDeviceEvent) {
        yield* _mapConnectBluetoothDeviceToState();
      } else if (event is CancelBluetoothDeviceEvent) {
        yield* _mapCancelBluetoothDeviceToState();
      } else if (event is DisconnectBluetoothDeviceEvent) {
        yield* _mapDisconnectBluetoothDeviceToState();
      } else if (event is DiscoverServicesBluetoothDeviceEvent) {
        yield* _mapDiscoverServicesBluetoothDeviceToState();
      } else if (event is RequestMtuBluetoothDeviceEvent) {
        yield* _mapRequestMtuBluetoothDeviceToState();
      } else if (event is DisposeBluetoothDeviceEvent) {
        yield* _mapDisposeBluetoothDeviceEventToState();
      }
    } catch (e) {
      emit(BluetoothDeviceErrorState(e));
    }
  }

  Stream<BluetoothDevicePageEvent> _mapInitBluetoothDeviceToState(BluetoothDevice bluetoothDevice) async* {
    print("_mapInitBluetoothDeviceToState1");
    device = MyBluetoothRepository.getDeviceRepository(bluetoothDevice)!;
    print("_mapInitBluetoothDeviceToState2");

    _connectionStateSubscription = device.connectionStateSubscription(doSomething: () {
      emit(ConnectionDeviceBluetoothDeviceState(currentConnectionState));
    });

    _mtuSubscription = device.mtuSubscription(doSomething: () {
      emit(MtuSizeDeviceBluetoothDeviceState(mtuSize));
    });

    _isConnectingSubscription = device.isConnectingSubscription(doSomething: () {
      emit(IsConnectingBluetoothDeviceState(isConnecting));
    });

    _isDisconnectingSubscription = device.isDisconnectingSubscription(doSomething: () {
      emit(IsDisconnectingBluetoothState(isDisconnecting));
    });
  }

  Stream<BluetoothDevicePageEvent> _mapConnectBluetoothDeviceToState() async* {
    device.connect(
        doSomething: () {
          emit(ConnectionDeviceBluetoothDeviceState(device.currentConnectionState));
        }
    );
  }

  Stream<BluetoothDevicePageEvent> _mapCancelBluetoothDeviceToState() async* {
    device.cancel(
        doSomething: () {
          emit(ConnectionDeviceBluetoothDeviceState(device.currentConnectionState));
        }
    );
  }

  Stream<BluetoothDevicePageEvent> _mapDisconnectBluetoothDeviceToState() async* {
    device.disconnect(
        doSomething: () {
          emit(ConnectionDeviceBluetoothDeviceState(device.currentConnectionState));
        }
    );
  }

  Stream<BluetoothDevicePageEvent> _mapDiscoverServicesBluetoothDeviceToState() async* {
    device.discoverServices(
        doSomething1: () {
          emit(DiscoverServicesBluetoothDeviceState(device.services, device.isDiscoveringServices));
        },
        doSomething2: () {
          emit(DiscoverServicesBluetoothDeviceState(device.services, device.isDiscoveringServices));
        }
    );
  }

  Stream<BluetoothDevicePageEvent> _mapRequestMtuBluetoothDeviceToState() async* {
    device.disconnect(
        doSomething: () {
          emit(MtuSizeDeviceBluetoothDeviceState(device.mtuSize));
        }
    );
  }

  Stream<BluetoothDevicePageEvent> _mapDisposeBluetoothDeviceEventToState() async* {
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
    _isConnectingSubscription.cancel();
    _isDisconnectingSubscription.cancel();
    emit(DisposedBluetoothDeviceState());
  }
}
