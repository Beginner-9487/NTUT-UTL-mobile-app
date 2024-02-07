import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/data_storage/ble_data_storage_interface.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/data_storage/mackay_irb/ble_data_storage_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/res/app_theme.dart';
import 'package:ntut_utl_mobile_app/res/experiment_parameters.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/bluetooth/device/bluetooth_device_bloc.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/bluetooth/device/bluetooth_device_event.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/bluetooth/device/bluetooth_device_state.dart';

class TileBLEMackayIRB extends StatefulWidget {
  const TileBLEMackayIRB({super.key, required this.device});

  final BLEDevice device;

  @override
  State<TileBLEMackayIRB> createState() => _TileBLEMackayIRBState(device);
}

class _TileBLEMackayIRBState extends State<TileBLEMackayIRB> with StatefulWithResStrings {

  _TileBLEMackayIRBState(this.device);
  final BLEDevice device;
  late BluetoothDvBloc bluetoothDvBloc;

  BLEDataStorageEvent<BLEDataStorage> get bleDataManagerServiceMackayIRB => ProjectParameters.bleDataManagerServiceMackayIRB;

  bool get isConnected => bluetoothDvBloc.isConnected;
  bool get connectable => bluetoothDvBloc.connectable;

  late TextEditingController _labelNameController;

  @override
  void initState() {
    super.initState();
    bluetoothDvBloc = BluetoothDvBloc(device);
    _labelNameController = TextEditingController(text: device.deviceName);
    setLabelName(_labelNameController.text);
  }

  @override
  void dispose() {
    bluetoothDvBloc.add(BluetoothDvEventDispose());
    super.dispose();
  }

  Future<BLECharacteristic?> _findCharacteristic(String uuid) async {
    if(!connectable || !isConnected) {
      return null;
    }
    await device.discoverServices();
    for(BLEService s in device.services) {
      for(BLECharacteristic c in s.characteristics) {
        if(c.uuid == uuid) {
          return c;
        }
      }
    }
  }

  Widget _buildTitle(BuildContext context) {
    if (device.deviceName.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            device.deviceName,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            device.deviceAddress,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    } else {
      return Text(device.rssi.toString());
    }
  }

  Widget _buildConnectButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: (connectable) ? () => {_connectButtonPress()} : null,
      child: isConnected ? Text(str.disconnect) : Text(str.connect),
    );
  }

  Widget _buildSendCommandButton(BuildContext context) {
    return IconButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: (connectable && isConnected) ? () => {_sendCommand()} : null,
      icon: const Icon(Icons.send),
    );
  }

  _connectButtonPress() {
    _changeConnectState();
  }

  _changeConnectState() async {
    if(!connectable) {return;}
    isConnected ? await device.disconnect() : await device.connect();
    BLECharacteristic? c = await _findCharacteristic(ExperimentTargetBLEUUID.MackaySubscribeUUID);
    if(c == null) {return;}
    c.setNotify(true);
    bleDataManagerServiceMackayIRB.addNewReceiverFromCharacteristic(c);
  }

  _sendCommand() async {
    if(!connectable || !isConnected) {return null;}
    BLECharacteristic? c = await _findCharacteristic(ExperimentTargetBLEUUID.MackaySendUUID);
    if(c == null) {return null;}
    c.writeData(ExperimentTargetBLECommand.MackayStart, delay: 300);
  }

  setLabelName(String labelName) {
    (bleDataManagerServiceMackayIRB.storage as BLEDataStorageMackayIRB).setDeviceName(device.deviceAddress, labelName);
  }

  Widget connectedTile(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: AppTheme.colorBLEConnectedBackground(context),
      title: ListTile(
        title: ListTile(
          title: TextField(
            controller: _labelNameController,
            onChanged: setLabelName,
          ),
          trailing: _buildSendCommandButton(context),
        ),
        contentPadding: const EdgeInsets.all(0.0),
      ),
      children: [
        ListTile(
          leading: Text(device.rssi.toString()),
          title: _buildTitle(context),
          trailing: _buildConnectButton(context),
        ),
      ],
    );
  }

  Widget disconnectedTile(BuildContext context) {
    return ListTile(
      tileColor: AppTheme.colorBLEDisconnectedBackground(context),
      title: _buildTitle(context),
      leading: Text(device.rssi.toString()),
      trailing: _buildConnectButton(context),
      // contentPadding: const EdgeInsets.all(0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothDvBloc, BluetoothDvState>(
        bloc: bluetoothDvBloc,
        builder: (context, blueState) {
          return isConnected ? connectedTile(context) : disconnectedTile(context);
        }
    );
  }
}