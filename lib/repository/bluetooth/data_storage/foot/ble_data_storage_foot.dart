import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';

import '../ble_data_storage_interface.dart';
import 'foot_entity.dart';

class _NestedBLEDataStorageFoot {
  // Because the bytes contain no information about what the device is,
  // data conflicts sometimes occur between each device.
  // That's why I need to know where the data comes from. (by deviceAddress)
  String deviceAddress;
  List<FootEntity> entities = [];
  _NestedBLEDataStorageFoot(this.deviceAddress);
}

class BLEDataStorageFoot implements BLEDataStorage {

  @override
  addNewDataFromCharacteristic(BLECharacteristic characteristic, List<int> bytes) {
    receiveNewData(characteristic.device.address, bytes);
  }

  @override
  addNewDataFromDescriptor(BLEDescriptor descriptor, List<int> bytes) {
    receiveNewData(descriptor.device.address, bytes);
  }

  static List<_NestedBLEDataStorageFoot> data = [];
  static List<FootEntity> getAllData() {
    List<FootEntity> allData = [];
    for (var element in data) {
      allData.addAll(element.entities);
    }
    return allData;
  }
  static _NestedBLEDataStorageFoot findNested(String deviceAddress) {
    for (var element in data) {
      if(element.deviceAddress == deviceAddress) {
        return element;
      }
    }
    data.add(_NestedBLEDataStorageFoot(deviceAddress));
    return data.last;
  }

  static FootEntity receiveNewData(String deviceAddress, List<int> bytes) {
    findNested(deviceAddress).entities.add(FootEntity(bytes));
    return findNested(deviceAddress).entities.last;
  }
}
