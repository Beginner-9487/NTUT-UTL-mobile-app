import 'dart:async';

import 'ble_interface.dart';

abstract class BLEDataWriter<ChDt> {
  final List<ChDt> _dataWriters = [];
  addNewDataWriter(ChDt chDt);
  removeDataWriter(ChDt chDt);
  sendCommand(ChDt chDt, List<int> value);
}

class BLEDataWriterCt extends BLEDataWriter<BLECharacteristic> {
  @override
  addNewDataWriter(BLECharacteristic chDt) {
    // Make sure old writer are removed to avoid duplicate event trigger.
    removeDataWriter(chDt);
    // Add new event.
    _dataWriters.add(chDt);
  }

  @override
  removeDataWriter(BLECharacteristic chDt) {
    for(int i=0; i<_dataWriters.length; i++) {
      if(_dataWriters[i].device.uuid == chDt.device.uuid) {
        _dataWriters.removeAt(i);
        return;
      }
    }
  }

  @override
  sendCommand(BLECharacteristic chDt, List<int> value, {int delay = 0}) {
    for(int i=0; i<_dataWriters.length; i++) {
      if(_dataWriters[i].device.uuid == chDt.device.uuid) {
        _dataWriters[i].writeData(value, delay: delay);
        return;
      }
    }
  }
}

class BLEDataWriterDt extends BLEDataWriter<BLEDescriptor> {
  @override
  addNewDataWriter(BLEDescriptor chDt) {
    // Make sure old writer are removed to avoid duplicate event trigger.
    removeDataWriter(chDt);
    // Add new event.
    _dataWriters.add(chDt);
  }

  @override
  removeDataWriter(BLEDescriptor chDt) {
    for(int i=0; i<_dataWriters.length; i++) {
      if(_dataWriters[i].device.uuid == chDt.device.uuid) {
        _dataWriters.removeAt(i);
        return;
      }
    }
  }

  @override
  sendCommand(BLEDescriptor chDt, List<int> value, {int delay = 0}) {
    for(int i=0; i<_dataWriters.length; i++) {
      if(_dataWriters[i].device.uuid == chDt.device.uuid) {
        _dataWriters[i].writeData(value, delay: delay);
        return;
      }
    }
  }
}











