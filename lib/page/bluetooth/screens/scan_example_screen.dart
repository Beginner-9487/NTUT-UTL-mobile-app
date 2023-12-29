import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/my_bluetooth_repository.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import '../../../utils/display_util.dart';
import '../bloc/main/bluetooth_bloc.dart';
import '../bloc/main/bluetooth_event.dart';
import '../bloc/main/bluetooth_state.dart';
import 'device_screen.dart';
import '../utils/snackbar.dart';
import '../widgets/example/system_device_tile.dart';
import '../widgets/example/scan_result_tile.dart';

class ScanExampleScreen extends StatefulWidget {
  static const ROUTER_NAME = '/ScanExampleScreen';

  const ScanExampleScreen({super.key});

  @override
  State<ScanExampleScreen> createState() => _ScanExampleScreenState();
}

class _ScanExampleScreenState extends State<ScanExampleScreen> with StateWithResStrings {
  BluetoothPageBloc bluetoothPageBloc = BluetoothPageBloc();

  List<BluetoothDevice> get _systemDevices => MyBluetoothRepository.getSystemDevices;
  List<ScanResult> get _scanResults => MyBluetoothRepository.scanResults;
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
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => DeviceScreen(device: device),
        settings: const RouteSettings(name: '/DeviceScreen')
    );
    Navigator.of(context).push(route);
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
        .map(
          (d) => SystemDeviceTile(
            device: d,
            onOpen: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DeviceScreen(device: d),
                settings: const RouteSettings(name: '/DeviceScreen'),
              ),
            ),
            onConnect: () => onConnectPressed(d),
          ),
        )
        .toList();
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: () => onConnectPressed(r.device),
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
