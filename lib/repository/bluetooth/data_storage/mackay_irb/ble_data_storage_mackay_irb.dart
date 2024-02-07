import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/data_storage/ble_data_storage_interface.dart';
import 'package:ntut_utl_mobile_app/utils/bytes_converter.dart';
import 'package:ntut_utl_mobile_app/utils/iterator_processor.dart';

import 'mackay_irb_entity.dart';

class _NestedBLEDataStorageMackayIRB {
  // Because the bytes contain no information about what the device is,
  // data conflicts sometimes occur between each device.
  // That's why I need to know where the data comes from. (by deviceAddress)
  String deviceAddress;
  String _deviceName;
  List<MackayIrbEntity> entities = [];
  _NestedBLEDataStorageMackayIRB(this.deviceAddress, this._deviceName);
  setDeviceName(String name) {
    _deviceName = name;
  }
  String getNewName() {
    DateTime today = DateTime.now();
    return "$_deviceName-${today.year}-${today.month}-${today.day}-${today.hour}-${today.minute}-${today.second}";
  }
  MackayIrbEntity getLastDataByTypeAndNumberOfData(int type, int numberOfData) {
    Iterator<MackayIrbEntity> d = entities.reversed.iterator;
    while (d.moveNext()) {
      if(
      !d.current.finished &&
          d.current.type == type &&
          d.current.numberOfData == numberOfData
      ) {
        return d.current;
      }
    }
    entities.add(
        MackayIrbEntity(
            getNewName(),
            type,
            numberOfData
        )
    );
    return entities.last;
  }
}

class BLEDataStorageMackayIRB implements BLEDataStorage {
  @override
  addNewDataFromCharacteristic(BLECharacteristic characteristic, List<int> bytes) {
    _receiveNewData((characteristic.device as BLEDevice).deviceAddress, bytes);
  }

  @override
  addNewDataFromDescriptor(BLEDescriptor descriptor, List<int> bytes) {
    _receiveNewData((descriptor.device as BLEDevice).deviceAddress, bytes);
  }

  List<_NestedBLEDataStorageMackayIRB> data = [];
  List<MackayIrbEntity> getAllData() {
    List<MackayIrbEntity> allData = [];
    for (var element in data) {
      allData.addAll(element.entities);
    }
    return allData;
  }
  _NestedBLEDataStorageMackayIRB findNested(String deviceAddress) {
    for (var element in data) {
      if(element.deviceAddress == deviceAddress) {
        return element;
      }
    }
    data.add(_NestedBLEDataStorageMackayIRB(
        deviceAddress,
        ""
    ));
    return data.last;
  }

  setDeviceName(String deviceAddress, String deviceName) {
    findNested(deviceAddress).setDeviceName(deviceName);
  }

  MackayIrbEntity _receiveNewData(String deviceAddress, List<int> bytes) {
    IteratorProcessor<int> iterator = IteratorProcessor(bytes);

    int type = BytesConverter.byteArrayToSignedInt(
        [iterator.takeOut()]
    );
    int numberOfData = BytesConverter.byteArrayToSignedInt(
        [iterator.takeOut(), iterator.takeOut()]
    );
    MackayIrbEntity mackayIRBEntity = findNested(deviceAddress).getLastDataByTypeAndNumberOfData(
        type,
        numberOfData
    );
    mackayIRBEntity.addNewData(
        iterator.takeOutList(12)
    );

    return mackayIRBEntity;
  }

}