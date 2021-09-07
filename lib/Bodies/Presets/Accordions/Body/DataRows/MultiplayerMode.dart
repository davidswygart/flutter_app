import 'package:flutter/material.dart';

class MultiplayerMode{
  late final DataRow dataRow;
  final Map settings;
  MultiplayerMode(this.settings){
    dataRow = DataRow(
      cells: <DataCell>[
        DataCell(Text('Multiplayer Mode')),
        DataCell((settings['Multiplayer Mode'] > 0)
            ? Text('Simultaneous')
            : Text('Asynchronous'),
          showEditIcon: settings['editable'],),
      ],
    );
  }
}
