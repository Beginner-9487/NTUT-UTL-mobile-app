import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/page/bluetooth/bloc/characteristic_and_descriptor/characteristic_and_descriptor_event.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import '../../../../utils/display_util.dart';
import '../../bloc/characteristic_and_descriptor/bloc/characteristic_and_descriptor_bloc.dart';
import '../../bloc/characteristic_and_descriptor/bloc/characteristic_and_descriptor_mixin.dart';
import '../../bloc/characteristic_and_descriptor/bloc/characteristic_and_descriptor_abstract.dart';
import '../../bloc/characteristic_and_descriptor/characteristic_and_descriptor_state.dart';
import '../../utils/snackbar.dart';


class DescriptorTile extends StatefulWidget {
  final BluetoothDescriptor descriptor;

  const DescriptorTile({super.key, required this.descriptor});

  @override
  State<DescriptorTile> createState() => _DescriptorTileState(descriptor);
}

class _DescriptorTileState extends State<DescriptorTile> with StateWithResStrings {
  late ChaDesBlocExample bluetoothChaDesPageBloc;
  _DescriptorTileState(BluetoothDescriptor descriptor) {
    bluetoothChaDesPageBloc = ChaDesBlocExampleBloc(descriptor: descriptor);
  }
  List<int> get _value => bluetoothChaDesPageBloc.lastValue;

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   _lastValueSubscription.cancel();
  //   super.dispose();
  // }

  BluetoothDescriptor get d => widget.descriptor;

  Uint8List _getRandomBytes() {
    final math = Random();
    return Uint8List.fromList([math.nextInt(255), math.nextInt(255), math.nextInt(255), math.nextInt(255)]);
  }

  Future onReadPressed() async {
    try {
      bluetoothChaDesPageBloc.add(ReadValueEvent());
      Snackbar.show(ABC.c, "Descriptor Read : Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Descriptor Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      bluetoothChaDesPageBloc.add(WriteValueEvent(_getRandomBytes()));
      Snackbar.show(ABC.c, "Descriptor Write : Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Descriptor Write Error:", e), success: false);
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.descriptor.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    return Text(data, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
      onPressed: onReadPressed,
      child: const Text("Read"),
    );
  }

  Widget buildWriteButton(BuildContext context) {
    return TextButton(
      onPressed: onWritePressed,
      child: const Text("Write"),
    );
  }

  Widget buildButtonRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildReadButton(context),
        buildWriteButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<BluetoothChaDesPageBloc>(
              create: (BuildContext context) => bluetoothChaDesPageBloc
          ),
        ],
        child: BlocListener(
            bloc: bluetoothChaDesPageBloc,
            listener: (context, state) {
              print("BlocListener: $state");
              if (state is ErrorState) {
                DisplayUtil.showMsg(
                    context, exception: state.exception as Exception?);
              }
            },
            child: BlocBuilder<BluetoothChaDesPageBloc,
                BluetoothChaDesPageState>(
                bloc: bluetoothChaDesPageBloc,
                builder: (context, state) {
                  return ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(str.descriptor),
                        buildUuid(context),
                        buildValue(context),
                      ],
                    ),
                    subtitle: buildButtonRow(context),
                  );
                }
            )
        )
    );
  }
}
