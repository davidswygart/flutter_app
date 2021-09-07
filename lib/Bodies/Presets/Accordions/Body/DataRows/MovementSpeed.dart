import 'package:flutter/material.dart';

class MovementSpeed{
  late final DataRow dataRow;
  final Map settings;
  MovementSpeed(this.settings){
    dataRow = DataRow(
      cells: <DataCell>[
        DataCell(Text('Movement Speed')),
        DataCell((settings['Movement Speed'] > 0)
            ? Text(settings['Movement Speed'].toString() + ' switch/min')
            : Text('Disabled'),
          showEditIcon: settings['editable'],),
      ],
    );
  }
}
