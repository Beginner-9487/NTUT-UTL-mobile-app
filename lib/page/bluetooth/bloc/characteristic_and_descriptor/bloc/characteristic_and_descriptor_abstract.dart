import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/my_bluetooth_device_repository.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/my_bluetooth_repository.dart';

import '../characteristic_and_descriptor_event.dart';
import '../characteristic_and_descriptor_state.dart';

abstract class BluetoothChaDesPageBloc extends Bloc<BluetoothChaDesPageEvent, BluetoothChaDesPageState> {

  MyBluetoothDeviceRepository? getDeviceRepository() {
    if(deviceRepository == null) {
      if(characteristic != null) {
        deviceRepository = MyBluetoothRepository.getDeviceRepository(characteristic!.device);
      } else if (descriptor != null) {
        deviceRepository = MyBluetoothRepository.getDeviceRepository(descriptor!.device);
      }
    }
    return deviceRepository;
  }
  MyBluetoothDeviceRepository? deviceRepository;
  BluetoothCharacteristic? characteristic;
  BluetoothDescriptor? descriptor;

  late StreamSubscription<List<int>> _onValueReceivedSubscription;

  @override
  static BluetoothChaDesPageState get initialState => InitState();

  onReceived(BluetoothCharacteristic? characteristic, BluetoothDescriptor? descriptor, List<int> v) {
    emit(ReceiveValueState(characteristic, descriptor, v));
  }
  onRead(BluetoothCharacteristic? characteristic, BluetoothDescriptor? descriptor, List<int> v) {
    emit(ReadValueState(characteristic, descriptor, v));
  }
  onWrite(BluetoothCharacteristic? characteristic, BluetoothDescriptor? descriptor, List<int> v) {
    emit(WriteValueState(characteristic, descriptor, v));
  }
  onSubscribe(BluetoothCharacteristic? characteristic, bool b) {
    emit(SubscribingState(characteristic, descriptor, b));
  }

  BluetoothChaDesPageBloc({this.characteristic, this.descriptor}) : super(initialState) {

    deviceRepository = getDeviceRepository();
    print("BluetoothChaDesPageState: $deviceRepository");
    _onValueReceivedSubscription = deviceRepository!.onValueReceivedSubscription(characteristic: characteristic, descriptor: descriptor, doSomething: onReceived)!;

    on<ReadValueEvent>((event, emit) {
      mapEventToState(event).first;
    });
    on<WriteValueEvent>((event, emit) {
      mapEventToState(event).first;
    });
    on<ChangeSubscribeEvent>((event, emit) {
      mapEventToState(event).first;
    });
    on<DisposeEvent>((event, emit) {
      mapEventToState(event).first;
    });
  }

  @override
  Stream<BluetoothChaDesPageEvent> mapEventToState(BluetoothChaDesPageEvent event) async* {
    print("BluetoothDeviceBloc: mapEventToState: $event");
    try {
      if (event is ReadValueEvent) {
        yield* _mapReadValueEventToState();
      } else if (event is WriteValueEvent) {
        yield* _mapWriteValueEventToState(event.value);
      } else if (event is ChangeSubscribeEvent) {
        yield* _mapChangeSubscribeValueEventToState();
      } else if (event is SetSubscribeEvent) {
        yield* _mapSetSubscribeEventEventToState(event.isNotify);
      } else if (event is DisposeEvent) {
        yield* _mapSetDisposeEventEventToState();
      }
    } catch (e) {
      emit(ErrorState(e));
    }
  }

  Stream<BluetoothChaDesPageEvent> _mapReadValueEventToState() async* {
    deviceRepository?.readValue(characteristic: characteristic, descriptor: descriptor, doSomething: onRead);
  }
  Stream<BluetoothChaDesPageEvent> _mapWriteValueEventToState(List<int> newValue) async* {
    deviceRepository?.writeValue(newValue, characteristic: characteristic, descriptor: descriptor, doSomething: onWrite);
  }
  Stream<BluetoothChaDesPageEvent> _mapChangeSubscribeValueEventToState() async* {
    deviceRepository?.changeNotify(characteristic: characteristic, doSomething: onSubscribe);
  }
  Stream<BluetoothChaDesPageEvent> _mapSetSubscribeEventEventToState(bool newValue) async* {
    deviceRepository?.setNotify(newValue, characteristic: characteristic, doSomething: onSubscribe);
  }
  Stream<BluetoothChaDesPageEvent> _mapSetDisposeEventEventToState() async* {
    _onValueReceivedSubscription.cancel();
    emit(DisposedState());
  }
}