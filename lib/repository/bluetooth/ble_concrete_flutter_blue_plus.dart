import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/flutter_blue_plus_peripheral_manager.dart';
import 'package:ntut_utl_mobile_app/ui/utils/extra.dart';

class BLEManagerFBP extends BLEManager<BLEDeviceFBP> {

  static BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _bluetoothAdapterSubscription;

  @override
  bool get isBluetoothOn => adapterState == BluetoothAdapterState.on;

  @override
  bool get isScanning => FlutterBluePlusPeripheralManager.isScanning;

  @override
  List<BLEDeviceFBP> get devices {
    List<BLEDeviceFBP> list = [];
    // list.addAll(FlutterBluePlusPeripheralManager.systemDevices.map((item) => BLEDeviceFBP.bySystemDevice(this, item)).toList());
    list.addAll(FlutterBluePlusPeripheralManager.scanResults.map((item) => BLEDeviceFBP.byScanResult(this, item)).toList());
    return list;
  }

  // ===========================================================================
  // Bluetooth Turn
  @override
  turnOn() async {
    FlutterBluePlusPeripheralManager.turnOn();
  }
  @override
  turnOff() async {
    FlutterBluePlusPeripheralManager.turnOff();
  }

  @override
  scanOn() {
    FlutterBluePlusPeripheralManager.scanOn();
  }

  @override
  scanOff() {
    FlutterBluePlusPeripheralManager.scanOff();
  }

  BLEManagerFBP() {
    _bluetoothAdapterSubscription = FlutterBluePlusPeripheralManager.bluetoothAdapterListen(
            (BluetoothAdapterState state) {
          adapterState = state;
        }
    );
    _bluetoothStateChangeDetector = FlutterBluePlusPeripheralManager.bluetoothAdapterListen(
            (BluetoothAdapterState state) => _bluetoothStateChangeController.sink.add(state == BluetoothAdapterState.on)
    );
    _scanResultsDetector = FlutterBluePlusPeripheralManager.scanResultsSubscription(
            (List<ScanResult> results) => _scanResultsController.sink.add(devices)
    );
  }

  // ===========================================================================
  static final StreamController<bool> _bluetoothStateChangeController = StreamController.broadcast();
  Stream<bool> get _bluetoothStateChangeStream => _bluetoothStateChangeController.stream;
  late StreamSubscription<BluetoothAdapterState> _bluetoothStateChangeDetector;
  @override
  StreamSubscription<bool> onBluetoothStateChangeSubscription(void Function(bool state) doSomething) {
    return _bluetoothStateChangeStream.listen((state) {
      doSomething(state);
    });
  }

  // ===========================================================================
  static final StreamController<List<BLEDeviceFBP>> _scanResultsController = StreamController.broadcast();
  Stream<List<BLEDeviceFBP>> get _scanResultsStream => _scanResultsController.stream;
  late StreamSubscription<List<ScanResult>> _scanResultsDetector;
  @override
  StreamSubscription<List<BLEDeviceFBP>> onNewDeviceFoundSubscription(void Function(List<BLEDeviceFBP> results) doSomething) {
    return _scanResultsStream.listen((results) {
      doSomething(results);
    });
  }

  // ===========================================================================
  @override
  StreamSubscription<bool> onScanningStateChangeSubscription(void Function(bool state) doSomething) {
    return FlutterBluePlusPeripheralManager.isScanningSubscription(doSomething);
  }

}

class BLEDeviceFBP extends BLEDevice {

  ScanResult? result;
  BluetoothDevice device;

  factory BLEDeviceFBP.byScanResult(BLEManagerFBP manager, ScanResult result) {
    return BLEDeviceFBP(manager, result: result, device: result.device);
  }
  factory BLEDeviceFBP.bySystemDevice(BLEManagerFBP manager, BluetoothDevice device) {
    return BLEDeviceFBP(manager, device: device);
  }
  init() {
    _onConnectingSubscription = onConnectingSubscription(
            (bool value) {
          isConnecting = value;
        }
    );
    _onDisconnectingSubscription = onDisconnectingSubscription(
            (bool value) {
          isDisconnecting = value;
        }
    );

    // Don't use discoverServices() while new devices are being found,
    // it could cause the entire app to become so laggy.
    // discoverServices();
  }

  BLEDeviceFBP(this.manager, {this.result, required this.device}) {
    init();
  }

  @override
  BLEManagerFBP manager;

  @override
  List<BLEServiceFBP> get services => bluetoothServices.map((item) => BLEServiceFBP(manager, this, item)).toList();

  @override
  String get deviceName => device.advName;
  @override
  String get deviceAddress => device.remoteId.str;
  @override
  int get rssi => ((result != null) ? result!.rssi : 0);
  @override
  int get mtuSize => device.mtuNow;
  @override
  bool get connectable => (result != null) ? result!.advertisementData.connectable : true;

  // ===========================================================================
  // Manufacturer Data
  @override
  String get manufacturerData => (result != null) ? _getNiceManufacturerData(result!.advertisementData.manufacturerData) : "";
  String _getNiceManufacturerData(Map<int, List<int>> data) {
    return data.entries
        .map((entry) => '${entry.key.toRadixString(16)}: ${_getNiceHexArray(entry.value)}')
        .join(', ')
        .toUpperCase();
  }
  String _getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  // ===========================================================================
  // Connect
  @override
  bool isConnecting = false;
  @override
  StreamSubscription<bool> onConnectingSubscription (void Function(bool isConnecting) doSomething) {
    return device.isConnecting.listen((isConnecting) async {
      doSomething(isConnecting);
    });
  }
  late StreamSubscription<bool> _onConnectingSubscription;

  @override
  bool isDisconnecting = false;
  @override
  StreamSubscription<bool> onDisconnectingSubscription (void Function(bool value) doSomething) {
    return device.isDisconnecting.listen((value) async {
      doSomething(value);
    });
  }
  late StreamSubscription<bool> _onDisconnectingSubscription;

  @override
  bool get isConnected => device.isConnected;

  @override
  Future<bool> connect() async {
    try {
      await device.connectAndUpdateStream();
      return true;
    } catch (e) {
      if (e is FlutterBluePlusException && e.code == FbpErrorCode.connectionCanceled.index) {
        // ignore connections canceled by the user
      } else {
        debugPrint("ERROR: Connect: $e");
      }
      return false;
    }
  }
  @override
  Future<bool> disconnect() async {
    try {
      await device.disconnectAndUpdateStream();
      return true;
    } catch (e) {
      debugPrint("ERROR: Disconnect: $e");
      return false;
    }
  }

  // ===========================================================================
  // Services
  @override
  bool isDiscoveringServices = false;
  List<BluetoothService> bluetoothServices = [];
  @override
  Future<bool> discoverServices() async {
    isDiscoveringServices = true;
    _discoveringServicesStateController.sink.add(isDiscoveringServices);
    _discoveringServicesResultsController.sink.add(services);
    try {
      bluetoothServices = await device.discoverServices();
      isDiscoveringServices = false;
      _discoveringServicesStateController.sink.add(isDiscoveringServices);
      _discoveringServicesResultsController.sink.add(services);
      return true;
    } catch (e) {
      debugPrint("ERROR: discoverServices: $e");
      isDiscoveringServices = false;
      _discoveringServicesStateController.sink.add(isDiscoveringServices);
      _discoveringServicesResultsController.sink.add(services);
      return false;
    }
  }

  // ===========================================================================
  // Mtu
  @override
  StreamSubscription<int> onRequestMtuSubscription(void Function(int mtu) doSomething) {
    return device.mtu.listen((mtu) async {
      doSomething(mtu);
    });
  }

  // ===========================================================================
  // Discovering Services
  static final StreamController<bool> _discoveringServicesStateController = StreamController.broadcast();
  Stream<bool> get _discoveringServicesStateStream => _discoveringServicesStateController.stream;
  late StreamSubscription<bool> _discoveringServicesStateDetector;
  @override
  StreamSubscription<bool> onDiscoveringServicesStateSubscription(void Function(bool isDiscoveringServices) doSomething) {
    return _discoveringServicesStateStream.listen((isDiscoveringServices) {
      doSomething(isDiscoveringServices);
    });
  }

  static final StreamController<List> _discoveringServicesResultsController = StreamController.broadcast();
  Stream<List> get _discoveringServicesResultsStream => _discoveringServicesResultsController.stream;
  late StreamSubscription<List> _discoveringServicesResultsDetector;
  @override
  StreamSubscription<List> onDiscoveringServicesResultsSubscription(void Function(List services) doSomething) {
    return _discoveringServicesResultsStream.listen((services) {
      doSomething(services);
    });
  }
}

class BLEServiceFBP extends BLEService {

  BluetoothService service;
  BLEServiceFBP(this.manager, this.device, this.service);

  @override
  BLEManagerFBP manager;

  @override
  BLEDeviceFBP device;

  @override
  String get uuid => service.uuid.str128;
  @override
  List<BLECharacteristicFBP> get characteristics => service.characteristics.map((item) => BLECharacteristicFBP(manager, device, this, item)).toList();
}

class BLECharacteristicFBP extends BLECharacteristic {

  BluetoothCharacteristic characteristic;
  BLECharacteristicFBP(this.manager, this.device, this.service, this.characteristic);

  @override
  BLEManagerFBP manager;

  @override
  BLEDeviceFBP device;

  @override
  BLEServiceFBP service;

  @override
  List<BLEDescriptorFBP> get descriptors => characteristic.descriptors.map((item) => BLEDescriptorFBP(manager, device, service, this, item)).toList();

  @override
  String get uuid => characteristic.uuid.str128;

  // ===========================================================================
  // Notify
  @override
  bool get isNotified => characteristic.isNotifying;
  @override
  Future<bool> changeNotify() async {
    await characteristic.setNotifyValue(!characteristic.isNotifying);
    return true;
  }
  @override
  Future<bool> setNotify(bool value) async {
    await characteristic.setNotifyValue(value);
    return true;
  }

  // ===========================================================================
  // Properties
  @override
  List<bool> get properties => getProperties();

  List<bool> getProperties() {
    CharacteristicProperties p = characteristic.properties;
    return [
      p.broadcast,
      p.read,
      p.writeWithoutResponse,
      p.write,
      p.notify,
      p.indicate,
      p.authenticatedSignedWrites,
      p.extendedProperties,
      p.notifyEncryptionRequired,
      p.indicateEncryptionRequired,
    ];
  }

  // ===========================================================================
  @override
  Future<List<int>> readData() async {
    return characteristic.read();
  }

  @override
  writeData(List<int> value, {int delay = 0}) async {
    if(delay == 0) {
      characteristic.write(value);
      return;
    }
    for(int v in value) {
      characteristic.write([v]);
      await Future.delayed(Duration(milliseconds: delay));
    }
  }

  @override
  StreamSubscription<List<int>>? onReadNotifiedDataSubscription(void Function(List<int> data) doSomething) {
      return characteristic.onValueReceived.listen((value) {
        // debugPrint("c onReadNotifiedDataSubscription: ${value.length}");
        doSomething(
            value);
      });
  }

  @override
  StreamSubscription<List<int>>? onReadAllDataSubscription(void Function(List<int> data) doSomething) {
    return characteristic.lastValueStream.listen((value) {
      // debugPrint("c onReadAllDataSubscription: ${value.length}");
      doSomething(
          value);
    });
  }
}

class BLEDescriptorFBP extends BLEDescriptor {
  BluetoothDescriptor descriptor;
  BLEDescriptorFBP(this.manager, this.device, this.service, this.characteristic, this.descriptor);

  @override
  BLEManagerFBP manager;

  @override
  BLEDeviceFBP device;

  @override
  BLEServiceFBP service;

  @override
  BLECharacteristicFBP characteristic;

  @override
  String get uuid => descriptor.uuid.str128;

  @override
  Future<List<int>> readData() async {
    return descriptor.read();
  }

  @override
  writeData(List<int> value, {int delay = 0}) async {
    if(delay == 0) {
      descriptor.write(value);
      return;
    }
    for(int v in value) {
      descriptor.write([v]);
      await Future.delayed(Duration(milliseconds: delay));
    }
  }

  @override
  StreamSubscription<List<int>>? onReadNotifiedDataSubscription(void Function(List<int> data) doSomething) {
    return descriptor.onValueReceived.listen((value) {
      // debugPrint("d onReadNotifiedDataSubscription: ${value.length}");
      doSomething(
          value);
    });
  }

  @override
  StreamSubscription<List<int>>? onReadAllDataSubscription(void Function(List<int> data) doSomething) {
    return descriptor.lastValueStream.listen((value) {
      // debugPrint("d onReadAllDataSubscription: ${value.length}");
      doSomething(
          value);
    });
  }
}