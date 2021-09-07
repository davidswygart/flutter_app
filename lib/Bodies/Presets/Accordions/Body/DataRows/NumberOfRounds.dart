import 'package:flutter/material.dart';

class NumberOfRounds{
late final DataRow dataRow;
final Map settings;
  NumberOfRounds(this.settings){
    dataRow = DataRow(
      cells: <DataCell>[
        DataCell(Text('Number of Rounds')),
        DataCell(Text(settings['Number of Rounds'].toString()),
          showEditIcon: settings['editable'],
        ),
      ],
    );
  }
}