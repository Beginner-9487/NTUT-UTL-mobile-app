import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/data_storage/ble_data_storage_interface.dart';

class BLEDataStorageNormal implements BLEDataStorage {
  Map<DeviceIdentifier, Map<String, Map<String, MapEntry<List<List<int>>, Map<String, List<List<int>>>>>>> data = {};

  _init(DeviceIdentifier deviceIdentifier, String serviceUuid, String characteristicUuid) {
    if (!data.containsKey(deviceIdentifier)) {
      data[deviceIdentifier] = {};
    }

    if (!data[deviceIdentifier]!.containsKey(serviceUuid)) {
      data[deviceIdentifier]![serviceUuid] = {};
    }

    if (!data[deviceIdentifier]![serviceUuid]!.containsKey(characteristicUuid)) {
      data[deviceIdentifier]![serviceUuid]![characteristicUuid] = const MapEntry(
          [],
          {}
      );
    }
  }

  @override
  void addNewDataFromCharacteristic(BLECharacteristic characteristic, List<int> bytes) {
    DeviceIdentifier deviceIdentifier = characteristic.device.remoteId;
    String serviceUuid = characteristic.service.uuid;
    String characteristicUuid = characteristic.uuid;

    _init(deviceIdentifier, serviceUuid, characteristicUuid);

    data[deviceIdentifier]![serviceUuid]![characteristicUuid]!.key.add(bytes);
  }

  @override
  void addNewDataFromDescriptor(BLEDescriptor descriptor, List<int> bytes) {
    DeviceIdentifier deviceIdentifier = descriptor.device.remoteId;
    String serviceUuid = descriptor.service.uuid;
    String characteristicUuid = descriptor.characteristic.uuid;
    String descriptorUuid = descriptor.uuid;

    _init(deviceIdentifier, serviceUuid, characteristicUuid);

    if (!data[deviceIdentifier]![serviceUuid]![characteristicUuid]!.value.containsKey(descriptorUuid)) {
      data[deviceIdentifier]![serviceUuid]![characteristicUuid]!.value[descriptorUuid] = [];
    }

    data[deviceIdentifier]![serviceUuid]![characteristicUuid]!.value[descriptorUuid]!.add(bytes);
  }

}
