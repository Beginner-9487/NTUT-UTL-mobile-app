import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/page/bluetooth/bloc/main/bluetooth_state.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/my_bluetooth_repository.dart';
import 'package:ntut_utl_mobile_app/res/index.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import '../../../utils/display_util.dart';
import '../bloc/main/bluetooth_bloc.dart';
import '../bloc/main/bluetooth_event.dart';
import '../utils/snackbar.dart';

class BluetoothOffScreen extends StatefulWidget {
  const BluetoothOffScreen({super.key});

  @override
  State<BluetoothOffScreen> createState() => BluetoothOffPageState();
}

class BluetoothOffPageState extends State<BluetoothOffScreen> with StateWithResStrings {
  BluetoothPageBloc bluetoothPageBloc = BluetoothPageBloc();

  BluetoothAdapterState get adapterState => MyBluetoothRepository.adapterState;

  Widget buildBluetoothOffIcon(BuildContext context) {
    return const Icon(
      Icons.bluetooth_disabled,
      size: 200.0,
      color: Colors.white54,
    );
  }

  Widget buildTitle(BuildContext context) {
    String? state = adapterState
        ?.toString()
        .split(".")
        .last;
    return Text(
      'Bluetooth Adapter is ${state ?? 'not available'}',
      style: Theme
          .of(context)
          .primaryTextTheme
          .titleSmall
          ?.copyWith(color: Colors.white),
    );
  }

  Widget buildTurnOnButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        child: Text(ResourceString.turn_off_bluetooth),
        onPressed: () {
          bluetoothPageBloc.add(TurnOnBluetooth());
        },
      ),
    );
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
            listenWhen: (previousState, currentState) {
              return currentState is BluetoothAdapterStatingState;
            },
            listener: (context, state) {
              print("BlocListener: $state");
              if (state is BluetoothPageErrorState) {
                DisplayUtil.showMsg(
                    context, exception: state.exception as Exception?);
              }
            },
            child: BlocBuilder<BluetoothPageBloc, BluetoothPageState>(
                bloc: bluetoothPageBloc,
                buildWhen: (previousState, currentState) {
                  return currentState is BluetoothAdapterStatingState;
                },
                builder: (context, state) {
                  return ScaffoldMessenger(
                    key: Snackbar.snackBarKeyA,
                    child: Scaffold(
                      backgroundColor: Colors.lightBlue,
                      body: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            buildBluetoothOffIcon(context),
                            buildTitle(context),
                            buildTurnOnButton(context),
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