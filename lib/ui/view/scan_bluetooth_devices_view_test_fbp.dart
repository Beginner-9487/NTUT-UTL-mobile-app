import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_concrete_flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/ble_interface.dart';
import 'package:ntut_utl_mobile_app/res/app_theme.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/bluetooth/manager/bluetooth_manager_bloc.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/bluetooth/manager/bluetooth_manager_event.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/bluetooth/manager/bluetooth_manager_state.dart';
import 'package:ntut_utl_mobile_app/ui/screen/flutter_blue_plus_example/made_by_me/device_screen_adaptor.dart';
import 'package:ntut_utl_mobile_app/ui/screen/flutter_blue_plus_example/made_by_me/device_screen_adaptor_write_input_value.dart';
import 'package:ntut_utl_mobile_app/ui/utils/snackbar.dart';
import 'package:ntut_utl_mobile_app/ui/widgets/flutter_blue_plus_example/made_by_me/bluetooth_device_tile_adaptor.dart';

class ScanBluetoothDevicesViewTestFBP extends StatefulWidget {
  static const ROUTER_NAME = '/ScanBluetoothDevicesViewTestFBP';

  PageStorageKey pageStorageKey;
  ScanBluetoothDevicesViewTestFBP(this.pageStorageKey, {super.key});

  @override
  State<ScanBluetoothDevicesViewTestFBP> createState() => _ScanBluetoothDevicesViewTestFBPState();
}

class _ScanBluetoothDevicesViewTestFBPState extends State<ScanBluetoothDevicesViewTestFBP> with StatefulWithResStrings {
  BluetoothManagerBloc bluetoothManagerBloc = BluetoothManagerBloc();

  List get _scanResults => bluetoothManagerBloc.devices;
  bool get _isScanning => bluetoothManagerBloc.isScanning;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bluetoothManagerBloc.add(BluetoothManagerEventDispose());
    super.dispose();
  }

  Future onScanPressed() async {
    bluetoothManagerBloc.add(BluetoothManagerEventScanOn());
  }

  Future onStopPressed() async {
    bluetoothManagerBloc.add(BluetoothManagerEventScanOff());
  }

  void onConnectPressed(BLEDevice device) {
    bluetoothManagerBloc.add(BluetoothManagerEventConnectDevice(device));
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => DeviceScreenAdaptorWriteInputValue.getScreen(device),
        settings: const RouteSettings(name: '/DeviceScreenInterfaceWriteInputValue')
    );
    Navigator.of(context).push(route);
  }

  Future onRefresh() {
    bluetoothManagerBloc.add(BluetoothManagerEventScanOn());
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

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return (_scanResults as List<BLEDeviceFBP>)
        .map(
          (bleDevice) => BluetoothDeviceTileAdaptor.getScreen(bleDevice,
              onTap: () => onConnectPressed(bleDevice),
              onOpen: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DeviceScreenAdaptorWriteInputValue.getScreen(bleDevice),
                  settings: const RouteSettings(name: '/DeviceScreenWriteInputValue'),
                ),
              ),
              onConnect: () => onConnectPressed(bleDevice),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<BluetoothManagerBloc>(
              create: (BuildContext context) => bluetoothManagerBloc
          ),
        ],
        child: BlocListener(
            bloc: bluetoothManagerBloc,
            listener: (context, state) {
              debugPrint("BlocListener: $state");
              if (state is BluetoothManagerStateError) {
                if (context != null) {
                  AppTheme.showMsg(context, exception: state.exception);
                }
              }
            },
            child: BlocBuilder<BluetoothManagerBloc, BluetoothManagerState>(
                bloc: bluetoothManagerBloc,
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
                            ..._buildScanResultTiles(context),
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