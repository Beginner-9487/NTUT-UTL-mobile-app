import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/my_bluetooth_device_repository.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/utils/useful_function.dart';

import '../../../repository/bluetooth/data_manager/my_bluetooth_data_manager_mackay_irb.dart';

class MyBLEDeviceTile extends StatefulWidget {
  final BluetoothDevice device;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final void Function(BluetoothDevice device, List<int> value) onSendCommand;

  const MyBLEDeviceTile({
    required this.device,
    required this.onConnect,
    required this.onDisconnect,
    required this.onSendCommand,
    super.key,
  });

  @override
  State<MyBLEDeviceTile> createState() => _SystemDeviceTileState();
}

class _SystemDeviceTileState extends State<MyBLEDeviceTile> with StateWithResStrings {

  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;

  @override
  void initState() {
    super.initState();
    _connectionStateSubscription = widget.device.connectionState.listen((state) {
      _connectionState = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  get SendingCommandBox => {
    EditableText(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      style: const TextStyle(fontSize: 18),
      cursorColor: Colors.blue,
      backgroundCursorColor: Colors.red,
      onSubmitted: (text) {
        List<int> value = hexStringToByteArray(text);
        widget.onSendCommand(widget.device, value);
      },
    )
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.device.platformName),
      subtitle: Text(widget.device.remoteId.toString()),
      trailing: ElevatedButton(
        onPressed: isConnected ? widget.onDisconnect : widget.onConnect,
        child: isConnected ? Text(str.disconnect) : Text(str.connect),
      ),
    );
  }
}
