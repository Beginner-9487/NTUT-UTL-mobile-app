import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/ui/utils/snackbar.dart';
import 'package:ntut_utl_mobile_app/ui/widgets/flutter_blue_plus_example/made_by_me/descriptor_tile_write_input_value.dart';
import 'package:ntut_utl_mobile_app/utils/bytes_converter.dart';

class CharacteristicTileWriteInputValue extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTileWriteInputValue> descriptorTiles;

  const CharacteristicTileWriteInputValue({super.key, required this.characteristic, required this.descriptorTiles});

  @override
  State<CharacteristicTileWriteInputValue> createState() => _CharacteristicTileWriteInputValueState();
}

class _CharacteristicTileWriteInputValueState extends State<CharacteristicTileWriteInputValue> {
  List<int> _value = [];

  late StreamSubscription<List<int>> _lastValueSubscription;

  late TextEditingController writeValueTextEditingController;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription = widget.characteristic.lastValueStream.listen((value) {
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

  BluetoothCharacteristic get c => widget.characteristic;

  List<int> _getWriteBytes() {
    return BytesConverter.hexStringToByteArray(writeValueTextEditingController.value.text);
  }

  Future onReadPressed() async {
    try {
      await c.read();
      Snackbar.show(ABC.c, "Read: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      await c.write(_getWriteBytes(), withoutResponse: c.properties.writeWithoutResponse);
      Snackbar.show(ABC.c, "Write: Success", success: true);
      if (c.properties.read) {
        await c.read();
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }

  Future onSubscribePressed() async {
    try {
      String op = c.isNotifying == false ? "Subscribe" : "Unsubscribe";
      await c.setNotifyValue(c.isNotifying == false);
      Snackbar.show(ABC.c, "$op : Success", success: true);
      if (c.properties.read) {
        await c.read();
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
      }
    );
  }

  Widget buildWriteTextField(BuildContext context) {
    return TextField(
      controller: writeValueTextEditingController,
    );
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
    return ExpansionTile(
      title: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Characteristic'),
            buildUuid(context),
            buildValue(context),
            if (widget.characteristic.properties.write) buildWriteTextField(context),
          ],
        ),
        subtitle: buildButtonRow(context),
        contentPadding: const EdgeInsets.all(0.0),
      ),
      children: widget.descriptorTiles,
    );
  }
}