import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/page/bluetooth/utils/extra.dart';

class MyBluetoothDeviceRepository extends Equatable {

  BluetoothDevice device;

  MyBluetoothDeviceRepository(this.device);

  @override
  List<Object?> get props => [device];

  int rssi = 0;
  int mtuSize = 0;
  BluetoothConnectionState currentConnectionState = BluetoothConnectionState.disconnected;
  List<BluetoothService> services = [];
  bool isDiscoveringServices = false;
  bool isConnecting = false;
  bool isDisconnecting = false;

  StreamSubscription<int> mtuSubscription ({void Function()? doSomething}) {
    return device.mtu.listen((value) {
      mtuSize = value;
      doSomething!();
    });
  }

  StreamSubscription<BluetoothConnectionState> connectionStateSubscription ({void Function()? doSomething}) {
    return device.connectionState.listen((state) async {
      currentConnectionState = state;
      rssi = await device.readRssi();
      doSomething!();
    });
  }

  StreamSubscription<bool> isConnectingSubscription ({void Function()? doSomething}) {
    return device.isConnecting.listen((value) async {
      isConnecting = value;
      doSomething!();
    });
  }

  StreamSubscription<bool> isDisconnectingSubscription ({void Function()? doSomething}) {
    return device.isDisconnecting.listen((value) async {
      isDisconnecting = value;
      doSomething!();
    });
  }

  Future<void> connect({void Function()? doSomething, void Function(Object)? error}) async {
    try {
      await device.connectAndUpdateStream();
      doSomething!();
    } catch (e) {
      if (e is FlutterBluePlusException && e.code == FbpErrorCode.connectionCanceled.index) {
        // ignore connections canceled by the user
      } else {
        error!(e);
        debugPrint("ERROR: Connect: $e");
      }
    }
  }

  Future<void> cancel({void Function()? doSomething, void Function(Exception)? error}) async {
    try {
      await device.disconnectAndUpdateStream(queue: false);
      doSomething!();
    } catch (e) {
      error != null ? (e) : ();
      debugPrint("ERROR: Cancel: $e");
    }
  }

  Future<void> disconnect({void Function()? doSomething, void Function(Exception)? error}) async {
    try {
      await device.disconnectAndUpdateStream();
      doSomething!();
    } catch (e) {
      error != null ? (e) : ();
      debugPrint("ERROR: Disconnect: $e");
    }
  }

  Future<void> discoverServices({void Function()? doSomething1, void Function()? doSomething2, void Function(Exception)? error}) async {
    isDiscoveringServices = true;
    doSomething1!();
    try {
      services = await device.discoverServices();
      isDiscoveringServices = false;
      doSomething2!();
    } catch (e) {
      debugPrint("ERROR: discoverServices: $e");
    }
  }

  Future<void> requestMtu({void Function()? doSomething, void Function(Exception)? error}) async {
    try {
      mtuSize = await device.requestMtu(223);
      doSomething!();
    } catch (e) {
      debugPrint("ERROR: discoverServices: $e");
    }
  }

  StreamSubscription<List<int>>? onValueReceivedSubscription(
      {
        BluetoothCharacteristic? characteristic,
        BluetoothDescriptor? descriptor,
        void Function(
            BluetoothCharacteristic? characteristic,
            BluetoothDescriptor? descriptor,
            List<int> v
            )? doSomething
      })
  {
    if (characteristic != null) {
      return characteristic.onValueReceived.listen((value) {
        doSomething!(
            characteristic,
            descriptor,
            value
        );
      });
    }
    else if(descriptor != null) {
      return descriptor.onValueReceived.listen((value) {
        doSomething!(
            characteristic,
            descriptor,
            value
        );
      });
    }
  }

  StreamSubscription<List<int>>? lastValueSubscription(
      {
        BluetoothCharacteristic? characteristic,
        BluetoothDescriptor? descriptor,
        void Function(
            BluetoothCharacteristic? characteristic,
            BluetoothDescriptor? descriptor,
            List<int> v
            )? doSomething
      })
  {
    if (characteristic != null) {
      return characteristic.lastValueStream.listen((value) {
        doSomething!(
            characteristic,
            descriptor,
            value
        );
      });
    }
    else if(descriptor != null) {
      return descriptor.lastValueStream.listen((value) {
        doSomething!(
            characteristic,
            descriptor,
            value
        );
      });
    }
  }

  Future<void> readValue(
      {
        BluetoothCharacteristic? characteristic,
        BluetoothDescriptor? descriptor,
        void Function(
            BluetoothCharacteristic? characteristic,
            BluetoothDescriptor? descriptor,
            List<int> v
            )? doSomething
      }
  ) async {
    if (characteristic != null) {
      doSomething!(characteristic, descriptor, await characteristic!.read());
    }
    else if(descriptor != null) {
      doSomething!(characteristic, descriptor, await descriptor!.read());
    }
  }

  Future<void> writeValue(
      List<int> value,
      {
        BluetoothCharacteristic? characteristic,
        BluetoothDescriptor? descriptor,
        void Function(
            BluetoothCharacteristic? characteristic,
            BluetoothDescriptor? descriptor,
            List<int> v
            )? doSomething
      }
  ) async {
    await characteristic!.write(value);
    await descriptor!.write(value);
    doSomething!(characteristic, descriptor, value);
  }

  Future<void> changeNotify(
      {
        BluetoothCharacteristic? characteristic,
        void Function(
            BluetoothCharacteristic? characteristic,
            bool b
            )? doSomething
      }
      ) async {
    await characteristic!.setNotifyValue(!characteristic.isNotifying);
    doSomething!(characteristic, characteristic.isNotifying);
  }

  Future<void> setNotify(
      bool value,
      {
        BluetoothCharacteristic? characteristic,
        void Function(
            BluetoothCharacteristic? characteristic,
            bool b
            )? doSomething
      }
      ) async {
    await characteristic!.setNotifyValue(value);
    doSomething!(characteristic, characteristic.isNotifying);
  }
}