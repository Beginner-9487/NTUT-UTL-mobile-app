import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/page/bluetooth/bloc/device/bluetooth_device_state.dart';
import 'package:ntut_utl_mobile_app/page/bluetooth/bloc/main/bluetooth_state.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import '../../../utils/display_util.dart';
import '../bloc/device/bluetooth_device_bloc.dart';
import '../bloc/device/bluetooth_device_event.dart';
import '../widgets/example/service_tile.dart';
import '../widgets/example/characteristic_tile.dart';
import '../widgets/example/descriptor_tile.dart';
import '../utils/snackbar.dart';

class DeviceScreen extends StatefulWidget {
  BluetoothDevice device;

  DeviceScreen({super.key, required this.device});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState(device);
}

class _DeviceScreenState extends State<DeviceScreen> with StateWithResStrings {
  late BluetoothDevicePageBloc bluetoothDevicePageBloc;
  _DeviceScreenState(BluetoothDevice bluetoothDevice) {
    bluetoothDevicePageBloc = BluetoothDevicePageBloc(bluetoothDevice);
  }

  int get rssi => bluetoothDevicePageBloc.device.rssi;

  int get mtuSize => bluetoothDevicePageBloc.device.mtuSize;

  BluetoothConnectionState get _connectionState =>
      bluetoothDevicePageBloc.device.currentConnectionState;

  List<BluetoothService> get _services =>
      bluetoothDevicePageBloc.device.services;

  bool get _isDiscoveringServices =>
      bluetoothDevicePageBloc.device.isDiscoveringServices;

  bool get _isConnecting => bluetoothDevicePageBloc.isConnecting;

  bool get _isDisconnecting => bluetoothDevicePageBloc.isDisconnecting;

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  @override
  void initState() {
    super.initState();
    bluetoothDevicePageBloc.add(InitBluetoothDeviceEvent(widget.device));
  }

  @override
  void dispose() {
    bluetoothDevicePageBloc.add(DisposeBluetoothDeviceEvent());
    super.dispose();
  }

  Future onConnectPressed() async {
    bluetoothDevicePageBloc.add(ConnectBluetoothDeviceEvent());
  }

  Future onCancelPressed() async {
    bluetoothDevicePageBloc.add(CancelBluetoothDeviceEvent());
  }

  Future onDisconnectPressed() async {
    bluetoothDevicePageBloc.add(DisconnectBluetoothDeviceEvent());
  }

  Future onDiscoverServicesPressed() async {
    bluetoothDevicePageBloc.add(DiscoverServicesBluetoothDeviceEvent());
  }

  Future onRequestMtuPressed() async {
    bluetoothDevicePageBloc.add(RequestMtuBluetoothDeviceEvent());
  }

  List<Widget> _buildServiceTiles(BuildContext context, BluetoothDevice d) {
    return _services
        .map(
          (s) =>
          ServiceTile(
            service: s,
            characteristicTiles: s.characteristics.map((c) =>
                _buildCharacteristicTile(c)).toList(),
          ),
    )
        .toList();
  }

  CharacteristicTile _buildCharacteristicTile(BluetoothCharacteristic c) {
    return CharacteristicTile(
      characteristic: c,
      descriptorTiles: c.descriptors.map((d) => DescriptorTile(descriptor: d))
          .toList(),
    );
  }

  Widget buildSpinner(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(14.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CircularProgressIndicator(
          backgroundColor: Colors.black12,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget buildRemoteId(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('${widget.device.remoteId}'),
    );
  }

  Widget buildRssiTile(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isConnected ? const Icon(Icons.bluetooth_connected) : const Icon(
            Icons.bluetooth_disabled),
        Text(((isConnected && rssi != null) ? '${rssi!} dBm' : ''), style: Theme
            .of(context)
            .textTheme
            .bodySmall)
      ],
    );
  }

  Widget buildGetServices(BuildContext context) {
    return IndexedStack(
      index: (_isDiscoveringServices) ? 1 : 0,
      children: <Widget>[
        TextButton(
          onPressed: onDiscoverServicesPressed,
          child: const Text("Get Services"),
        ),
        const IconButton(
          icon: SizedBox(
            width: 18.0,
            height: 18.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.grey),
            ),
          ),
          onPressed: null,
        )
      ],
    );
  }

  Widget buildMtuTile(BuildContext context) {
    return ListTile(
        title: const Text('MTU Size'),
        subtitle: Text('$mtuSize bytes'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onRequestMtuPressed,
        ));
  }

  Widget buildConnectButton(BuildContext context) {
    return Row(children: [
      if (_isConnecting || _isDisconnecting) buildSpinner(context),
      TextButton(
          onPressed: _isConnecting ? onCancelPressed : (isConnected
              ? onDisconnectPressed
              : onConnectPressed),
          child: Text(
            _isConnecting ? "CANCEL" : (isConnected ? "DISCONNECT" : "CONNECT"),
            style: Theme
                .of(context)
                .primaryTextTheme
                .labelLarge
                ?.copyWith(color: Colors.white),
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<BluetoothDevicePageBloc>(
              create: (BuildContext context) => bluetoothDevicePageBloc
          ),
        ],
        child: BlocListener(
            bloc: bluetoothDevicePageBloc,
            listener: (context, state) {
              print("BlocListener: $state");
              if (state is BluetoothDeviceErrorState) {
                DisplayUtil.showMsg(
                    context, exception: state.exception as Exception?);
              }
            },
            child: BlocBuilder<BluetoothDevicePageBloc,
                BluetoothDevicePageState>(
                bloc: bluetoothDevicePageBloc,
                builder: (context, state) {
                  return ScaffoldMessenger(
                    key: Snackbar.snackBarKeyC,
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(widget.device.platformName),
                        actions: [buildConnectButton(context)],
                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            buildRemoteId(context),
                            ListTile(
                              leading: buildRssiTile(context),
                              title: Text('Device is ${_connectionState
                                  .toString().split(
                                  '.')[1]}.'),
                              trailing: buildGetServices(context),
                            ),
                            buildMtuTile(context),
                            ..._buildServiceTiles(context, widget.device),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            )
        )
    );
  }
}