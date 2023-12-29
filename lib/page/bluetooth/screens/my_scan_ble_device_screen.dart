import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/page/bluetooth/widgets/my_ble_device_tile.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/my_bluetooth_repository.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import '../../../utils/display_util.dart';
import '../bloc/main/bluetooth_bloc.dart';
import '../bloc/main/bluetooth_event.dart';
import '../bloc/main/bluetooth_mixin.dart';
import '../bloc/main/bluetooth_state.dart';
import '../utils/snackbar.dart';

// =================================================================
// Mackay
class MackayScanBLEDeviceScreen extends StatefulWidget {
  @override
  static String get ROUTER_NAME => '/MackayScanBLEDeviceScreen';
  const MackayScanBLEDeviceScreen({super.key});
  @override
  State<MyScanBLEDeviceScreen> createState() => _MackayState();
}
class _MackayState extends _MyScanBLEDeviceScreenState with StateWithResStrings {
  @override
  static BluetoothPageBloc get initBloc => MackayBluetoothPageBloc();
}

// =================================================================
// Normal
class MyScanBLEDeviceScreen extends StatefulWidget {
  static String get ROUTER_NAME => '/MyScanBLEDeviceScreen';

  const MyScanBLEDeviceScreen({super.key});

  @override
  State<MyScanBLEDeviceScreen> createState() => _MyScanBLEDeviceScreenState();
}

class _MyScanBLEDeviceScreenState extends State<MyScanBLEDeviceScreen> with StateWithResStrings {
  static BluetoothPageBloc get initBloc => BluetoothPageBloc();
  BluetoothPageBloc bluetoothPageBloc = initBloc;

  List<BluetoothDevice> get _systemDevices => MyBluetoothRepository.getAllDevices;
  bool get _isScanning => MyBluetoothRepository.isScanning;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bluetoothPageBloc.add(DisposeBluetooth());
    super.dispose();
  }

  Future onScanPressed() async {
    bluetoothPageBloc.add(ScanOnBluetooth());
  }

  Future onStopPressed() async {
    bluetoothPageBloc.add(ScanOffBluetooth());
  }

  void onConnectPressed(BluetoothDevice device) {
    bluetoothPageBloc.add(ConnectDeviceBluetooth(device));
  }
  void onDisconnectPressed(BluetoothDevice device) {
    bluetoothPageBloc.add(DisconnectDeviceBluetooth(device));
  }
  void onSendCommand(BluetoothDevice device, List<int> value) {
    bluetoothPageBloc.add(SendCommandDeviceBluetooth(device, value));
  }

  Future onRefresh() {
    bluetoothPageBloc.add(ScanOnBluetooth());
    return Future.delayed(const Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (_isScanning) {
      return FloatingActionButton(
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
        child: const Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton(
          onPressed: onScanPressed,
          child: const Icon(Icons.bluetooth_searching)
      );
    }
  }

  List<Widget> _buildSystemDeviceTiles(BuildContext context) {
    return _systemDevices
        .map((d) =>
          MyBLEDeviceTile(
            device: d,
            onConnect: () => onConnectPressed(d),
            onDisconnect: () => onDisconnectPressed(d),
            onSendCommand: onSendCommand,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<BluetoothPageBloc>(
              create: (BuildContext context) => bluetoothPageBloc
          ),
        ],
        child: BlocListener(
            bloc: bluetoothPageBloc,
            listener: (context, state) {
              print("BlocListener: $state");
              if (state is BluetoothPageErrorState) {
                DisplayUtil.showMsg(
                    context, exception: state.exception as Exception?);
              }
            },
            child: BlocBuilder<BluetoothPageBloc, BluetoothPageState>(
                bloc: bluetoothPageBloc,
                builder: (context, state) {
                  return ScaffoldMessenger(
                    key: Snackbar.snackBarKeyB,
                    child: Scaffold(
                      // appBar: AppBar(
                      //   title: const Text('Find Devices'),
                      // ),
                      body: RefreshIndicator(
                        onRefresh: onRefresh,
                        child: ListView(
                          children: <Widget>[
                            ..._buildSystemDeviceTiles(context),
                          ],
                        ),
                      ),
                      floatingActionButton: buildScanButton(context),
                    ),
                  );
                }
            )
        )
    );
  }
}
