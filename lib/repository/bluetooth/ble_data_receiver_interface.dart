import 'dart:async';

import 'ble_interface.dart';

abstract class BLEDataReceiver<ChDt> {
  final List<MapEntry<ChDt, StreamSubscription<List<int>>?>> _dataReceivers = [];
  addNewReceiver(ChDt chDt, void Function(ChDt chDt, List<int> data) doSomething);
  removeDataReceiver(ChDt chDt);
}

class BLEDataReceiverCt extends BLEDataReceiver<BLECharacteristic> {
  @override
  addNewReceiver(BLECharacteristic chDt, void Function(BLECharacteristic chDt, List<int> data) doSomething) {
    MapEntry<BLECharacteristic, StreamSubscription<List<int>>?> targetEvent = MapEntry(
        chDt,
        chDt.onReadNotifiedDataSubscription((List<int> data) => {
          doSomething(chDt, data)
        })
    );
    // Make sure old receiver are removed to avoid duplicate event trigger.
    removeDataReceiver(chDt);
    // Add new event.
    _dataReceivers.add(targetEvent);
  }

  @override
  removeDataReceiver(BLECharacteristic chDt) {
    for(int i=0; i<_dataReceivers.length; i++) {
      if(_dataReceivers[i].key.device.uuid == chDt.device.uuid) {
        _dataReceivers[i].value!.cancel();
        _dataReceivers.removeAt(i);
        return;
      }
    }
  }
}

class BLEDataReceiverDt extends BLEDataReceiver<BLEDescriptor> {
  @override
  addNewReceiver(BLEDescriptor chDt, void Function(BLEDescriptor chDt, List<int> data) doSomething) {
    MapEntry<BLEDescriptor, StreamSubscription<List<int>>?> targetEvent = MapEntry(
        chDt,
        chDt.onReadNotifiedDataSubscription((List<int> data) => {
          doSomething(chDt, data)
        })
    );
    // Make sure old receiver are removed to avoid duplicate event trigger.
    removeDataReceiver(chDt);
    // Add new event.
    _dataReceivers.add(targetEvent);
  }

  @override
  removeDataReceiver(BLEDescriptor chDt) {
    for(int i=0; i<_dataReceivers.length; i++) {
      if(_dataReceivers[i].key.device.uuid == chDt.device.uuid) {
        _dataReceivers[i].value!.cancel();
        _dataReceivers.removeAt(i);
        return;
      }
    }
  }
}