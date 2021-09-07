import 'package:flutter/material.dart';

class RoundTimeout{
  late final DataRow dataRow;
  final Map settings;
  RoundTimeout(this.settings){
    dataRow = DataRow(
      cells: <DataCell>[
        DataCell(Text('Round Timeout')),
        DataCell((settings['Round Timeout'] > 0)
            ? Text(settings['Round Timeout'].toString() + ' ms')
            : Text('Disabled'),
          showEditIcon: settings['editable'],),
      ],
    );
  }
}