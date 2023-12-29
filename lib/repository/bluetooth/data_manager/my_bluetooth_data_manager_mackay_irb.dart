import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../entity/mackay_irb_entity.dart';
import '../../../utils/useful_function.dart';

class MackayIrbDataManager {
  static List<MackayIrbEntity> data = [];
  static List<MapEntry<BluetoothCharacteristic, StreamSubscription<List<int>>?>> registeredCharacteristics = [];
  static List<BluetoothCharacteristic> prepareForWritingCharacteristics = [];

  // ===========================================================================
  // Listen for new Mackay Data
  static final StreamController<
      MapEntry<BluetoothCharacteristic, MackayIrbEntity>
  > onNewMackayDataReceivedController = StreamController<MapEntry<BluetoothCharacteristic, MackayIrbEntity>>();

  static Stream<MapEntry<
      BluetoothCharacteristic, MackayIrbEntity>
  > get onNewMackayDataReceivedStream => onNewMackayDataReceivedController.stream;

  static StreamSubscription<
      MapEntry<BluetoothCharacteristic, MackayIrbEntity>
  >? onNewMackayDataReceivedSubscription(
      {
        void Function(
            BluetoothCharacteristic characteristic,
            MackayIrbEntity mackayIrbEntity
            )? doSomething
      })
  {
    return onNewMackayDataReceivedStream.listen((entry) {
      doSomething!(
          entry.key,
          entry.value
      );
    });
  }

  static unregisterCharacteristicForListenNewMackayData(BluetoothCharacteristic characteristic) {
    for(int i=0; i<registeredCharacteristics.length; i++) {
      if(
          registeredCharacteristics[i].key.remoteId == characteristic.remoteId &&
          registeredCharacteristics[i].key.characteristicUuid == characteristic.characteristicUuid
      ) {
        registeredCharacteristics[i].value!.cancel();
        registeredCharacteristics.removeAt(i);
        return;
      }
    }
  }

  static registerCharacteristicForListenNewMackayData(BluetoothCharacteristic characteristic) {
    MapEntry<
        BluetoothCharacteristic, StreamSubscription<List<int>>?
    > targetEvent = MapEntry(
        characteristic,
        characteristic.onValueReceived.listen((value) {
          MackayIrbEntity mackayIrbEntity = receiveNewData(characteristic, value);
          onNewMackayDataReceivedController.sink.add(MapEntry(characteristic, mackayIrbEntity));
        })
    );
    unregisterCharacteristicForListenNewMackayData(characteristic);
    registeredCharacteristics.add(targetEvent);
  }
  // ===========================================================================
  // Write command to device
  static unregisterCharacteristicForWriteCommand(BluetoothCharacteristic characteristic) {
    for(int i=0; i<prepareForWritingCharacteristics.length; i++) {
      if(
          prepareForWritingCharacteristics[i].remoteId == characteristic.remoteId &&
          prepareForWritingCharacteristics[i].characteristicUuid == characteristic.characteristicUuid
      ) {
        prepareForWritingCharacteristics.removeAt(i);
        return;
      }
    }
  }

  static registerCharacteristicForWriteCommand(BluetoothCharacteristic characteristic) {
    unregisterCharacteristicForWriteCommand(characteristic);
    prepareForWritingCharacteristics.add(characteristic);
  }

  static sendCommand(BluetoothCharacteristic characteristic, List<int> value) {
    for(int i=0; i<prepareForWritingCharacteristics.length; i++) {
      if(
          prepareForWritingCharacteristics[i].remoteId == characteristic.remoteId &&
          prepareForWritingCharacteristics[i].characteristicUuid == characteristic.characteristicUuid
      ) {
        prepareForWritingCharacteristics[i].write(value);
        return;
      }
    }
  }
  // ===========================================================================

  static String getNewName() {
    return "";
  }

  static MackayIrbEntity getLastDataByTypeAndNumberOfData(int type, int numberOfData) {
    Iterator<MackayIrbEntity> d = data.reversed.iterator;
    while (d.moveNext()) {
      if(
          !d.current.finished &&
          d.current.type == type &&
          d.current.numberOfData == numberOfData
      ) {
        return d.current;
      }
    }
    data.add(
        MackayIrbEntity(
            getNewName(),
            type,
            numberOfData
        )
    );
    return data.last;
  }

  static MackayIrbEntity receiveNewData(BluetoothCharacteristic characteristic, List<int> bytes) {
    Int8List int8List = Int8List.fromList(bytes);
    IteratorProcessor<int> iterator = IteratorProcessor(int8List);

    int type = byteArrayToSignedInt(
        [iterator.takeOut()]
    );
    int numberOfData = byteArrayToSignedInt(
        [iterator.takeOut(), iterator.takeOut()]
    );
    MackayIrbEntity item = getLastDataByTypeAndNumberOfData(
        type,
        numberOfData
    );
    item.addNewData(
        iterator.takeOutList(12)
    );

    return item;
  }
}
