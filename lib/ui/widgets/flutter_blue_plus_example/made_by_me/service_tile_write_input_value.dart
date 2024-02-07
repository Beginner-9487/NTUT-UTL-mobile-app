import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ntut_utl_mobile_app/ui/widgets/flutter_blue_plus_example/made_by_me/characteristic_tile_write_input_value.dart';

class ServiceTileWriteInputValue extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTileWriteInputValue> characteristicTiles;

  const ServiceTileWriteInputValue({super.key, required this.service, required this.characteristicTiles});

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${service.uuid.str.toUpperCase()}';
    return Text(uuid, style: TextStyle(fontSize: 13));
  }

  @override
  Widget build(BuildContext context) {
    return characteristicTiles.isNotEmpty
        ? ExpansionTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Service', style: TextStyle(color: Colors.blue)),
          buildUuid(context),
        ],
      ),
      children: characteristicTiles,
    )
        : ListTile(
      title: const Text('Service'),
      subtitle: buildUuid(context),
    );
  }
}