import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/ui/utils/snackbar.dart';
import 'package:ntut_utl_mobile_app/utils/bytes_converter.dart';

class DescriptorTileWriteInputValue extends StatefulWidget {
  final BluetoothDescriptor descriptor;

  const DescriptorTileWriteInputValue({super.key, required this.descriptor});

  @override
  State<DescriptorTileWriteInputValue> createState() => _DescriptorTileWriteInputValueState();
}

class _DescriptorTileWriteInputValueState extends State<DescriptorTileWriteInputValue> {
  List<int> _value = [];

  late StreamSubscription<List<int>> _lastValueSubscription;

  late TextEditingController writeValueTextEditingController;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription = widget.descriptor.lastValueStream.listen((value) {
      _value = value;
      setState(() {});
    });
    writeValueTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BluetoothDescriptor get d => widget.descriptor;

  List<int> _getWriteBytes() {
    return BytesConverter.hexStringToByteArray(writeValueTextEditingController.value.text);
  }

  Future onReadPressed() async {
    try {
      await d.read();
      Snackbar.show(ABC.c, "Descriptor Read : Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Descriptor Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      await d.write(_getWriteBytes());
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

  Widget buildWriteTextField(BuildContext context) {
    return TextField(
      controller: writeValueTextEditingController,
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
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Descriptor'),
          buildUuid(context),
          buildValue(context),
          buildWriteTextField(context),
        ],
      ),
      subtitle: buildButtonRow(context),
    );
  }
}