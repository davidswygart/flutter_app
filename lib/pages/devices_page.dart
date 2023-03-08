import 'package:flutter/material.dart';

import '../bluetooth/bluetooth_handler.dart';
import '../bluetooth/single_target.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({Key? key}) : super(key: key);

  @override
  State<DevicesPage> createState() => _DevicesPage();
}

class _DevicesPage extends State<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    Widget connectButton = ElevatedButton(
      onPressed: () {
        addTargetsAndUpdate();
      },
      child: const Text("Scan for targets"),
    );

    Widget clearTargetsButton = ElevatedButton(
      onPressed: () {
        clearTargetsAndUpdate();
      },
      child: const Text("Clear Targets"),
    );

    Widget forceUpdateButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: force update button pressed');
        setState(() {});
      },
      child: const Text("force update"),
    );

    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 50),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            connectButton,
            Container(color: Colors.white70,child: targetTable(),),
            clearTargetsButton,
            forceUpdateButton,
          ],
        ),
      ),
    );
  }

  DataTable targetTable() {
    List<DataColumn> columns = [
    const DataColumn(label: Text("name")),
    const DataColumn(label: Text("rssi")),
    ];

    List<DataRow> rows = [];
    for (SingleTarget target in BlueToothHandler().targetList) {
      debugPrint(target.device.name);
      List<DataCell> rowCells = [
        DataCell(Text(target.device.name)),
        DataCell(Text(target.device.rssi.toString())),
      ];
      rows.add(DataRow(cells: rowCells));
    }

    return DataTable(columns: columns, rows: rows);
  }

  addTargetsAndUpdate() async {
    await BlueToothHandler().connectToTargets();
    setState(() {});
  }

  clearTargetsAndUpdate() async {
    await BlueToothHandler().clearTargets();
    setState(() {});
  }
}
