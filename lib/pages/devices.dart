import 'package:flutter/material.dart';

import '../bluetooth/bluetooth_handler.dart';
import '../bluetooth/led_display.dart';
import '../bluetooth/single_target.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({Key? key}) : super(key: key);

  @override
  State<DevicesPage> createState() => _DevicesPage();
}

class _DevicesPage extends State<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          functionButton(func: addTargetsAndUpdate, label: "Connect to targets"),
          getDeviceTable(),
          functionButton(func: clearTargets, label: "Disconnect from targets"),
          functionButton(func:LedDisplay().cycleLeds, label: "Flash LEDs")
        ],
      ),
    );
  }

  Container getDeviceTable() {
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
    return Container(
        decoration: BoxDecoration(
            border: Border.all()
        ),
        child: DataTable(columns: columns, rows: rows)
    );
  }

  ElevatedButton functionButton({required Function func, required String label}){
    return ElevatedButton(
      onPressed: () {func();},
      child: Text(label),
    );
  }

  addTargetsAndUpdate() async {
    await BlueToothHandler().connectToTargets();
    setState(() {});
  }

  clearTargets() async {
    await BlueToothHandler().clearTargets(); //TODO make disconnect if connected and ESP32 start advertising again
    setState(() {});
  }
}
