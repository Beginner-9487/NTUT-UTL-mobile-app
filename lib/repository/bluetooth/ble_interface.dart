import 'dart:async';

abstract class BLEManager<Device> {
  bool get isBluetoothOn;
  bool get isScanning;
  List<Device> get devices;
  turnOn();
  turnOff();
  scanOn();
  scanOff();
  StreamSubscription<bool> onBluetoothStateChangeSubscription(void Function(bool state) doSomething);
  StreamSubscription<bool> onScanningStateChangeSubscription(void Function(bool state) doSomething);
  StreamSubscription<List<Device>> onNewDeviceFoundSubscription(void Function(List<Device> results) doSomething);
}

abstract class BLEDevice<Manager, Service> {
  Manager get manager;
  List<Service> get services;

  String get deviceName;
  String get deviceAddress;
  int get rssi;
  int get mtuSize;
  String get manufacturerData;
  bool get connectable;

  bool get isConnecting;
  bool get isDisconnecting;
  bool get isConnected;
  Future<bool> connect();
  Future<bool> disconnect();

  bool get isDiscoveringServices;
  Future<bool> discoverServices();

  StreamSubscription<int> onRequestMtuSubscription(void Function(int mtu) doSomething);
  StreamSubscription<bool> onConnectingSubscription(void Function(bool isConnecting) doSomething);
  StreamSubscription<bool> onDisconnectingSubscription(void Function(bool isDisonnecting) doSomething);
  StreamSubscription<bool> onDiscoveringServicesStateSubscription(void Function(bool isDiscoveringServices) doSomething);
  StreamSubscription<List<Service>> onDiscoveringServicesResultsSubscription(void Function(List<Service> services) doSomething);
}

abstract class BLEService<Manager, Device, Characteristic> {
  Manager get manager;
  Device get device;
  List<Characteristic> get characteristics;

  String get uuid;
}

abstract class BLECharacteristic<Manager, Device, Service, Descriptor> {
  Manager get manager;
  Device get device;
  Service get service;
  List<Descriptor> get descriptors;

  String get uuid;

  bool get isNotified;
  Future<bool> changeNotify();
  Future<bool> setNotify(bool value);

  List<bool> get properties;
  static int get broadcast => 0;
  static int get read => 1;
  static int get writeWithoutResponse => 2;
  static int get write => 3;
  static int get notify => 4;
  static int get indicate => 5;
  static int get authenticatedSignedWrites => 6;
  static int get extendedProperties => 7;
  static int get notifyEncryptionRequired => 8;
  static int get indicateEncryptionRequired => 9;

  Future<List<int>> readData();
  writeData(List<int> value, {int delay = 0});

  StreamSubscription<List<int>>? onReadNotifiedDataSubscription(void Function(List<int> data) doSomething) {}
  StreamSubscription<List<int>>? onReadAllDataSubscription(void Function(List<int> data) doSomething) {}
}

abstract class BLEDescriptor<Manager, Device, Service, Characteristic> {
  Manager get manager;
  Device get device;
  Service get service;
  Characteristic get characteristic;

  String get uuid;

  Future<List<int>> readData();
  writeData(List<int> value, {int delay = 0});

  StreamSubscription<List<int>>? onReadNotifiedDataSubscription(void Function(List<int> data) doSomething) {}
  StreamSubscription<List<int>>? onReadAllDataSubscription(void Function(List<int> data) doSomething) {}
}