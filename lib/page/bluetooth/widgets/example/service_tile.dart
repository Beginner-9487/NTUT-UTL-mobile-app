import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../../res/project_parameters.dart';
import 'characteristic_tile.dart';

class ServiceTile extends StatelessWidget with StatelessWidgetWithResStrings {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  ServiceTile({super.key, required this.service, required this.characteristicTiles});

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${service.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  @override
  Widget buildWithContext(BuildContext context) {
    return characteristicTiles.isNotEmpty
        ? ExpansionTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(str.service, style: const TextStyle(color: Colors.blue)),
                buildUuid(context),
              ],
            ),
            children: characteristicTiles,
          )
        : ListTile(
            title: Text(str.service),
            subtitle: buildUuid(context),
          );
  }
}
