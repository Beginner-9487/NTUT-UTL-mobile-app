import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyBluetoothDataManagerNormal {
  Map<DeviceIdentifier, Map<Guid, Map<Guid, MapEntry<List<List<int>>, Map<Guid, List<List<int>>>>>>> data = {};

  _init(DeviceIdentifier deviceIdentifier, Guid serviceUuid, Guid characteristicUuid) {
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

  void addNewDataIntoCharacteristic(BluetoothCharacteristic characteristic, List<int> newData) {
    DeviceIdentifier deviceIdentifier = characteristic.device.remoteId;
    Guid serviceUuid = characteristic.serviceUuid;
    Guid characteristicUuid = characteristic.characteristicUuid;

    _init(deviceIdentifier, serviceUuid, characteristicUuid);

    data[deviceIdentifier]![serviceUuid]![characteristicUuid]!.key.add(newData);
  }
  void addNewDataIntoDescriptor(BluetoothDescriptor descriptor, List<int> newData) {
    DeviceIdentifier deviceIdentifier = descriptor.device.remoteId;
    Guid serviceUuid = descriptor.serviceUuid;
    Guid characteristicUuid = descriptor.characteristicUuid;
    Guid descriptorUuid = descriptor.descriptorUuid;

    _init(deviceIdentifier, serviceUuid, characteristicUuid);

    if (!data[deviceIdentifier]![serviceUuid]![characteristicUuid]!.value.containsKey(descriptorUuid)) {
      data[deviceIdentifier]![serviceUuid]![characteristicUuid]!.value[descriptorUuid] = [];
    }

    data[deviceIdentifier]![serviceUuid]![characteristicUuid]!.value[descriptorUuid]!.add(newData);
  }
}
