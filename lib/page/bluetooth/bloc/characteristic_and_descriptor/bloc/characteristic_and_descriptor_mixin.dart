import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'characteristic_and_descriptor_abstract.dart';

mixin ChaDesBlocExample on BluetoothChaDesPageBloc {
  List<List<int>> value = [];
  List<int> get lastValue => value.isNotEmpty ? value.last : [];
  @override
  onReceived(BluetoothCharacteristic? characteristic, BluetoothDescriptor? descriptor, List<int> v){
    value.add(v);
    super.onReceived(characteristic, descriptor, v);
  }
  @override
  onRead(BluetoothCharacteristic? characteristic, BluetoothDescriptor? descriptor, List<int> v){
    value.add(v);
    super.onRead(characteristic, descriptor, v);
  }
  @override
  onWrite(BluetoothCharacteristic? characteristic, BluetoothDescriptor? descriptor, List<int> v){
    value.add(v);
    super.onWrite(characteristic, descriptor, v);
  }
}

mixin NullWrite on BluetoothChaDesPageBloc {
  @override
  onWrite(characteristic, descriptor, List<int> v){}
}

mixin NullSubscribe on BluetoothChaDesPageBloc {
  @override
  onSubscribe(characteristic, bool b){}
}