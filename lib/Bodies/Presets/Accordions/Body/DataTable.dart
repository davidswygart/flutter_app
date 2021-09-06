import 'package:flutter/material.dart';

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
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Number of Rounds')),
            DataCell(Text(settings['Number of Rounds'].toString())),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Delay between Rounds')),
            DataCell(Text(settings['Delay between Rounds'].toString() + ' ms')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Multiplayer Mode')),
            DataCell((settings['Multiplayer Mode'] > 0)
                ? Text('Simultaneous')
                : Text('Asynchronous')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Movement Speed')),
            DataCell((settings['Movement Speed'] > 0)
                ? Text(settings['Movement Speed'].toString() + ' switch/min')
                : Text('Disabled')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Light Timeout')),
            DataCell((settings['Light Timeout'] > 0)
                ? Text(settings['Light Timeout'].toString() + ' ms')
                : Text('Disabled')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Round Timeout')),
            DataCell((settings['Round Timeout'] > 0)
                ? Text(settings['Round Timeout'].toString() + ' ms')
                : Text('Disabled')),
          ],
        ),
      ],
    );
  }
}