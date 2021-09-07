import 'package:flutter/material.dart';

import 'DataRows/DelayBetweenRounds.dart';
import 'DataRows/LightTimeout.dart';
import 'DataRows/MovementSpeed.dart';
import 'DataRows/MultiplayerMode.dart';
import 'DataRows/NumberOfRounds.dart';
import 'DataRows/RoundTimeout.dart';

class SettingsDataTable extends StatelessWidget{
  final Map settings;
  SettingsDataTable({required this.settings});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowHeight: 0,
      columns: const <DataColumn>[
        DataColumn(label: Text('name')),
        DataColumn(label: Text('value'))
      ],
      rows: <DataRow>[
        NumberOfRounds(settings).dataRow,
        DelayBetweenRounds(settings, context).dataRow,
        MultiplayerMode(settings).dataRow,
        MovementSpeed(settings).dataRow,
        LightTimeout(settings).dataRow,
        RoundTimeout(settings).dataRow,
      ],
    );
  }
}