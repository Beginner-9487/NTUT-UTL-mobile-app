import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/page/bluetooth/bloc/characteristic_and_descriptor/characteristic_and_descriptor_state.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import '../../../../utils/display_util.dart';
import '../../bloc/characteristic_and_descriptor/bloc/characteristic_and_descriptor_bloc.dart';
import '../../bloc/characteristic_and_descriptor/bloc/characteristic_and_descriptor_mixin.dart';
import '../../bloc/characteristic_and_descriptor/bloc/characteristic_and_descriptor_abstract.dart';
import '../../bloc/characteristic_and_descriptor/characteristic_and_descriptor_event.dart';
import '../../utils/snackbar.dart';

import 'descriptor_tile.dart';

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;

  const CharacteristicTile({super.key, required this.characteristic, required this.descriptorTiles});

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState(characteristic);
}

class _CharacteristicTileState extends State<CharacteristicTile> with StateWithResStrings {
  late ChaDesBlocExample bluetoothChaDesPageBloc;
  _CharacteristicTileState(BluetoothCharacteristic characteristic) {
    bluetoothChaDesPageBloc = ChaDesBlocExampleBloc(characteristic: characteristic);
  }

  List<int> get _value => bluetoothChaDesPageBloc.lastValue;
  BluetoothCharacteristic get c => widget.characteristic;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bluetoothChaDesPageBloc.add(DisposeEvent());
    super.dispose();
  }

  Uint8List _getRandomBytes() {
    final math = Random();
    return Uint8List.fromList([math.nextInt(255), math.nextInt(255), math.nextInt(255), math.nextInt(255)]);
  }

  Future onReadPressed() async {
    try {
      bluetoothChaDesPageBloc.add(ReadValueEvent());
      Snackbar.show(ABC.c, "Read: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      bluetoothChaDesPageBloc.add(WriteValueEvent(_getRandomBytes()));
      Snackbar.show(ABC.c, "Write: Success", success: true);
      if (c.properties.read) {
        bluetoothChaDesPageBloc.add(ReadValueEvent());
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }

  Future onSubscribePressed() async {
    try {
      String op = c.isNotifying == false ? "Subscribe" : "Unsubscribe";
      bluetoothChaDesPageBloc.add(ChangeSubscribeEvent());
      Snackbar.show(ABC.c, "$op : Success", success: true);
      if (c.properties.read) {
        bluetoothChaDesPageBloc.add(ReadValueEvent());
      }
      setState(() {});
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Subscribe Error:", e), success: false);
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.characteristic.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    return Text(data, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
        child: const Text("Read"),
        onPressed: () async {
          await onReadPressed();
          setState(() {});
        });
  }

  Widget buildWriteButton(BuildContext context) {
    bool withoutResp = widget.characteristic.properties.writeWithoutResponse;
    return TextButton(
        child: Text(withoutResp ? "WriteNoResp" : "Write"),
        onPressed: () async {
          await onWritePressed();
          setState(() {});
        });
  }

  Widget buildSubscribeButton(BuildContext context) {
    bool isNotifying = widget.characteristic.isNotifying;
    return TextButton(
        child: Text(isNotifying ? "Unsubscribe" : "Subscribe"),
        onPressed: () async {
          await onSubscribePressed();
          setState(() {});
        });
  }

  Widget buildButtonRow(BuildContext context) {
    bool read = widget.characteristic.properties.read;
    bool write = widget.characteristic.properties.write;
    bool notify = widget.characteristic.properties.notify;
    bool indicate = widget.characteristic.properties.indicate;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (read) buildReadButton(context),
        if (write) buildWriteButton(context),
        if (notify || indicate) buildSubscribeButton(context),
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
              return ExpansionTile(
                title: ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(str.characteristic),
                      buildUuid(context),
                      buildValue(context),
                    ],
                  ),
                  subtitle: buildButtonRow(context),
                  contentPadding: const EdgeInsets.all(0.0),
                ),
                children: widget.descriptorTiles,
              );
            }
          )
        )
    );
  }
}
