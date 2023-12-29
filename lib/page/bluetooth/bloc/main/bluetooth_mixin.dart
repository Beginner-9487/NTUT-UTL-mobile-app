import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/data_manager/my_bluetooth_data_manager_mackay_irb.dart';

import '../../../../res/project_parameters.dart';
import 'bluetooth_bloc.dart';
import 'bluetooth_event.dart';
import 'bluetooth_state.dart';

mixin MackayBluetoothPageMixin on BluetoothPageBloc {
  @override
  void registerEvent() {
    super.registerEvent();
    on<SendCommandDeviceBluetooth>((event, emit) {
      mapEventToState(event).first;
    });
  }
  @override
  Stream<BluetoothPageState> mapEventToState(BluetoothPageEvent event) async* {
    super.mapEventToState(event);
    try {
      if (event is SendCommandDeviceBluetooth) {
        yield* _mapSendCommandDeviceBluetoothToState(event.device, event.value);
      }
    } catch (e) {
      emit(BluetoothPageErrorState(e));
    }
  }
  _mapSendCommandDeviceBluetoothToState(BluetoothDevice device, List<int> value) {
    emit(SendCommandDeviceBluetoothState(device, value));
    onSendCommandDevice(device, value);
  }
  @override
  onConnectDevice(BluetoothDevice device) {
    for(BluetoothService s in device.servicesList) {
      for(BluetoothCharacteristic c in s.characteristics) {
        if(c.characteristicUuid.str == TargetBLEUUID.MackaySubscribeUUID) {
          c.setNotifyValue(true);
          MackayIrbDataManager.registerCharacteristicForListenNewMackayData(c);
        }
        if(c.characteristicUuid.str == TargetBLEUUID.MackaySendUUID) {
          MackayIrbDataManager.registerCharacteristicForWriteCommand(c);
        }
      }
    }
  }
  @override
  onDisconnectDevice(BluetoothDevice device) {
    for(BluetoothService s in device.servicesList) {
      for(BluetoothCharacteristic c in s.characteristics) {
        if(c.characteristicUuid.str == TargetBLEUUID.MackaySubscribeUUID) {
          MackayIrbDataManager.unregisterCharacteristicForListenNewMackayData(c);
        }
        if(c.characteristicUuid.str == TargetBLEUUID.MackaySendUUID) {
          MackayIrbDataManager.unregisterCharacteristicForWriteCommand(c);
        }
      }
    }
  }
  onSendCommandDevice(BluetoothDevice device, List<int> value) {
    for (BluetoothService s in device.servicesList) {
      for (BluetoothCharacteristic c in s.characteristics) {
        if (c.characteristicUuid.str == TargetBLEUUID.MackaySendUUID) {
          MackayIrbDataManager.sendCommand(c, value);
        }
      }
    }
  }
}

class MackayBluetoothPageBloc extends BluetoothPageBloc with MackayBluetoothPageMixin {}