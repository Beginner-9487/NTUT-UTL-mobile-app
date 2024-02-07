import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../ble_data_receiver_interface.dart';
import '../ble_interface.dart';

abstract class BLEDataStorage {
  addNewDataFromCharacteristic(BLECharacteristic characteristic, List<int> bytes);
  addNewDataFromDescriptor(BLEDescriptor descriptor, List<int> bytes);
}

class BLEDataStorageEvent<Storage extends BLEDataStorage> {

  Storage storage;
  final BLEDataReceiverCt _receiverCt = BLEDataReceiverCt();
  final BLEDataReceiverDt _receiverDt = BLEDataReceiverDt();
  BLEDataStorageEvent(this.storage);

  addNewReceiverFromCharacteristic(BLECharacteristic chDt) {
    _receiverCt.addNewReceiver(chDt, (chDt, data) {
      storage.addNewDataFromCharacteristic(chDt, data);
      _dataUpdateFinish(storage);
    });
  }
  removeReceiverFromCharacteristic(BLECharacteristic chDt) {
    _receiverCt.removeDataReceiver(chDt);
  }
  addNewReceiverFromDescriptor(BLEDescriptor chDt) {
    _receiverDt.addNewReceiver(chDt, (chDt, data) {
      storage.addNewDataFromDescriptor(chDt, data);
      _dataUpdateFinish(storage);
    });
  }
  removeReceiverFromDescriptor(BLEDescriptor chDt) {
    _receiverDt.removeDataReceiver(chDt);
  }
  _dataUpdateFinish(Storage data) {
    _dataUpdateDetectorController.sink.add(data);
  }

  final StreamController<Storage> _dataUpdateDetectorController = StreamController.broadcast();
  Stream<Storage> get _dataUpdateDetector => _dataUpdateDetectorController.stream;
  StreamSubscription<void> onDataUpdateSubscription(void Function() doSomething) {
    return _dataUpdateDetector.listen((a) {
      doSomething();
    });
  }

}