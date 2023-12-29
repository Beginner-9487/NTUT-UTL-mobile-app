import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import '../../../repository/bluetooth/my_bluetooth_repository.dart';
import '../../../utils/display_util.dart';
import '../bloc/main/bluetooth_bloc.dart';
import '../bloc/main/bluetooth_event.dart';
import '../bloc/main/bluetooth_state.dart';
import '../screens/bluetooth_off_screen.dart';

class BluetoothExamplePage extends StatefulWidget {
  static get ROUTER_NAME => '/BluetoothExample';
  Widget get targetScreen => const BluetoothOffScreen();

  PageStorageKey pageStorageKey;
  BluetoothExamplePage(this.pageStorageKey, {super.key});

  @override
  State<BluetoothExamplePage> createState() => BluetoothExamplePageState(targetScreen);
}

class BluetoothExamplePageState extends State<BluetoothExamplePage> with StateWithResStrings {
  BluetoothExamplePageState(this.targetScreen);

  BluetoothPageBloc bluetoothPageBloc = BluetoothPageBloc();
  Widget targetScreen;

  BluetoothAdapterState get _adapterState => MyBluetoothRepository.adapterState;
  Widget get screen => _adapterState == BluetoothAdapterState.on
      ? targetScreen
      : const BluetoothOffScreen();

  @override
  void initState() {
    super.initState();
    bluetoothPageBloc.add(InitBluetooth());
  }

  @override
  void dispose() {
    bluetoothPageBloc.add(DisposeBluetooth());
    super.dispose();
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
                  return Scaffold(
                      body: screen
                  );
                }
            )
        )
    );
  }
}