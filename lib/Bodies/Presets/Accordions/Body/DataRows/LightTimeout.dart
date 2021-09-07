import 'package:flutter/material.dart';

class LightTimeout{
  late final DataRow dataRow;
  final Map settings;
  LightTimeout(this.settings){
    dataRow = DataRow(
      cells: <DataCell>[
        DataCell(Text('Light Timeout')),
        DataCell((settings['Light Timeout'] > 0)
            ? Text(settings['Light Timeout'].toString() + ' ms')
            : Text('Disabled'),
          showEditIcon: settings['editable'],),
      ],
    );
  }
}
